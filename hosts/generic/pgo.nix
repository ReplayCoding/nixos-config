{pkgs, ...}: let
  dir = "/var/cache/llvm-profdata";
in {
  systemd.tmpfiles.rules = ["d ${dir} 0777 - - 2d"];
  environment = {
    sessionVariables.LLVM_PROFILE_FILE = "${dir}/%p-%h-%m.profraw";
    systemPackages = [(pkgs.extract-pgo-data.override {pgoDir = dir;})];
  };
}
