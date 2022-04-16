#!/usr/bin/env python3
import sys, os, re, subprocess, json, tempfile, concurrent.futures
from typing import Dict

log = lambda s: print(s, file=sys.stderr)


class OutputProfileWrapper:
    def __init__(self, fname, delete=False):
        self.fname = fname
        self.delete = delete

    def __repr__(self):
        return f"<OutputProfileWrapper fname={self.fname} delete={self.delete}>"


class OutputProfileGroup:
    def __init__(self, pgo_type: str):
        self.profiles: list[OutputProfileWrapper] = []
        self.pgo_type = pgo_type

    def add_profiles(self, profiles: list[OutputProfileWrapper]):
        self.profiles += profiles

    def __repr__(self):
        return f"<OutputProfileGroup groups={profiles}>"


ProfileMappings = Dict[str, OutputProfileGroup]


class Extractor:
    def __init__(self):
        with open("@serialisedMappings@", "r") as serialised_data_file:
            self.serialised_data = json.load(serialised_data_file)

    @property
    def build_id_mappings(self):
        return self.serialised_data["build_ids"]

    @property
    def elf_files_in_drvs(self):
        return self.serialised_data["elf_files"]

    def get_pgo_support_data(self, drv):
        return self.serialised_data["pgo_support"][drv]

    @staticmethod
    def generate_data_cache():
        pgo_packages = """ @pgoPackagesWithBuildId@ """.strip().split("\n")
        build_id_mappings = {}
        pgo_support_data = {}
        files_that_are_elf = {}
        pattern = re.compile(r"Build ID: ([a-fA-F0-9]+)")
        for pgo_package in pgo_packages:
            files_that_are_elf[pgo_package] = []
            pgo_support_path_for_drv = os.path.join(
                pgo_package, "nix-support/pgo-support"
            )
            with open(pgo_support_path_for_drv, "r") as pgo_support_file:
                pgo_support = json.load(pgo_support_file)
                pgo_support_data[pgo_package] = pgo_support
            for root, dirs, files in os.walk(pgo_package):
                for file in files:
                    fullpath = os.path.join(root, file)
                    if os.path.islink(fullpath):
                        continue
                    llvm_readelf_headers_output = subprocess.run(
                        ["@libllvm@/bin/llvm-readelf", "-h", fullpath],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL,
                    )
                    if llvm_readelf_headers_output.returncode == 0:
                        files_that_are_elf[pgo_package] += [fullpath]
                    else:
                        continue
                    llvm_binary_id_output = subprocess.run(
                        ["@libllvm@/bin/llvm-readelf", "-n", fullpath],
                        capture_output=True,
                    )
                    if llvm_binary_id_output.returncode == 0:
                        llvm_binary_id_output = llvm_binary_id_output.stdout.decode(
                            "utf-8"
                        )
                    else:
                        continue
                    build_id = pattern.search(llvm_binary_id_output)
                    if build_id != None:
                        build_id = build_id.group(1)
                        build_id_mappings[build_id] = pgo_package
        return {
            "build_ids": build_id_mappings,
            "elf_files": files_that_are_elf,
            "pgo_support": pgo_support_data,
        }


class LLVMPerfdataExtractor(Extractor):
    def __init__(self, profiles):
        super().__init__()
        self.profiles = profiles
        self.max_workers = 12

    @staticmethod
    def _process_elf_file(script_file, elf: str):
        with tempfile.NamedTemporaryFile(delete=False) as output_profile:
            profgen_cmd = subprocess.run(
                [
                    "@libllvm@/bin/llvm-profgen",
                    "--perfscript={}".format(script_file.name),
                    "--binary={}".format(elf),
                    "--output={}".format(output_profile.name),
                ],
                stderr=subprocess.DEVNULL,
                stdout=subprocess.DEVNULL,
            )
            if profgen_cmd.returncode == 0:
                return output_profile
        return None

    def get_profiles(self) -> ProfileMappings:
        profiles_for_drvs: ProfileMappings = {}
        for drv in self.elf_files_in_drvs:
            pgo_support_data = self.get_pgo_support_data(drv)
            if pgo_support_data["type"] == "sample":
                profiles_for_drvs[pgo_support_data["name"]] = OutputProfileGroup(
                    pgo_support_data["type"]
                )
        for profile in self.profiles:
            with tempfile.NamedTemporaryFile() as script_file:
                perf_script_cmd = subprocess.run(
                    [
                        "@perf@/bin/perf",
                        "script",
                        "-F",
                        "ip,brstack",
                        "--show-mmap-events",
                        "-i",
                        profile,
                    ],
                    stdout=script_file,
                    stderr=subprocess.DEVNULL,
                )
                if perf_script_cmd.returncode != 0:
                    log("WARNING: Profile {} could not be parsed".format(profile))
                    continue
                with concurrent.futures.ThreadPoolExecutor(
                    max_workers=self.max_workers
                ) as executor:
                    profile_to_drv: Dict = {}
                    for drv in self.elf_files_in_drvs:
                        pgo_name = self.get_pgo_support_data(drv)["name"]
                        if pgo_name not in profiles_for_drvs:
                            continue
                        profile_to_drv |= {
                            executor.submit(
                                self._process_elf_file, script_file, elf
                            ): pgo_name
                            for elf in self.elf_files_in_drvs[drv]
                        }
                    for future in concurrent.futures.as_completed(profile_to_drv):
                        profile = future.result()
                        pgo_name = profile_to_drv[future]
                        if profile != None:
                            profiles_for_drvs[pgo_name].add_profiles(
                                [OutputProfileWrapper(profile.name, delete=True)]
                            )
        return profiles_for_drvs


class LLVMProfdataExtractor(Extractor):
    def __init__(self, pgo_dir):
        super().__init__()
        self.pgo_dir = pgo_dir

    def get_profiles(self) -> ProfileMappings:
        pattern = re.compile("Binary IDs: \n([a-fA-F0-9]+)", re.MULTILINE)

        profile_groups: ProfileMappings = {}
        ungrouped_profiles = []
        # Initialize profile groups
        for profile_group in self.build_id_mappings.values():
            pgo_support_data = self.get_pgo_support_data(profile_group)
            if pgo_support_data["type"] == "instr":
                profile_groups[pgo_support_data["name"]] = OutputProfileGroup(
                    pgo_support_data["type"]
                )

        for profile in os.scandir(self.pgo_dir):
            llvm_cmd = subprocess.run(
                ["@libllvm@/bin/llvm-profdata", "show", "--binary-ids", profile.path],
                capture_output=True,
            )
            if llvm_cmd.returncode != 0:
                log("WARNING: Profile {} could not be parsed".format(profile.name))
                continue
            llvm_output = llvm_cmd.stdout.decode("utf-8")
            build_id = pattern.search(llvm_output)
            if build_id == None:
                log(
                    "NOTE: Profile {} does not contain a binary id".format(profile.name)
                )
                ungrouped_profiles += [OutputProfileWrapper(profile.path)]
                continue
            assert build_id is not None  # Ugly hack to get mypy to behave
            if build_id.group(1) not in self.build_id_mappings:
                log("NOTE: Ignoring profile {}".format(profile.name))
                continue
            mapping = self.build_id_mappings[build_id.group(1)]
            program_profile_name = self.get_pgo_support_data(mapping)["name"]
            # If it isn't in the profile groups list, it isn't an instr profile
            if program_profile_name in profile_groups:
                profile_groups[program_profile_name].add_profiles(
                    [OutputProfileWrapper(profile.path)]
                )
        for profile_group in profile_groups:
            profile_groups[profile_group].add_profiles(ungrouped_profiles)
        return profile_groups


class LLVMProfdataMerger:
    @classmethod
    def merge_all_profiles(cls, profile_mappings: ProfileMappings):
        for program in profile_mappings:
            profile_group = profile_mappings[program]
            input_profiles = profile_group.profiles
            if len(input_profiles) > 1:
                cls.llvm_merge_profiles_to_profdata(
                    program, input_profiles, profile_group.pgo_type
                )
            else:
                log("\tNo profiles for profile {}".format(program))

    @staticmethod
    def llvm_merge_profiles_to_profdata(
        output_name: str, input_profiles: list[OutputProfileWrapper], pgo_type: str
    ):
        # getProfilePath = name: (./pgo + "/${super.nixosPassthru.hostname}-${name}.profdata");
        output_path = "{}-{}.profdata".format("@hostname@", output_name)
        profile_fnames = list(map(lambda p: p.fname, input_profiles))
        log("Merging profiles to {}".format(output_path))
        cmd = [
            "@libllvm@/bin/llvm-profdata",
            "merge",
            "--{}".format(pgo_type),
            "--text",
            "--output={}".format(output_path),
        ] + profile_fnames
        llvm_output = subprocess.run(cmd)
        if llvm_output.returncode != 0:
            log("Failed to merge profiles {}".format(", ".join(profile_fnames)))


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Utility to create PGO profiles from raw data"
    )
    parser.add_argument("-S", "--sampling-profiles", nargs="*")
    parser.add_argument("-I", "--instr-profiles-dir", default="@pgoDir@")
    parser.add_argument("--generate", action="store_true")
    args = parser.parse_args()
    if args.generate:
        serialised_build_id_mappings = json.dumps(Extractor.generate_data_cache())
        print(serialised_build_id_mappings)
    else:
        all_profiles: ProfileMappings = {}
        if args.sampling_profiles != None:
            all_profiles |= LLVMPerfdataExtractor(args.sampling_profiles).get_profiles()
        all_profiles |= LLVMProfdataExtractor(args.instr_profiles_dir).get_profiles()
        LLVMProfdataMerger.merge_all_profiles(all_profiles)
