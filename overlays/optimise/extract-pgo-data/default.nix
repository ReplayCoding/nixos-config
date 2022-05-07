{
  stdenv,
  python3,
  mypy,
  llvmPackages_14,
  linuxPackages,
  pkgsToExtractBuildId,
  nixosPassthru,
  pgoDir ? nixosPassthru.llvmProfdataDir,
}: let
  pkgsWithAllOutputs = builtins.concatMap (pkg: builtins.map (output: pkg.${output}) pkg.outputs);
  pkgsToExtractBuildId' = builtins.concatStringsSep "\n" (builtins.map toString (pkgsWithAllOutputs pkgsToExtractBuildId));
  pythonWithPkgs = python3.withPackages (p: with p; [rich]);
in
  stdenv.mkDerivation {
    name = "pgo-script";
    src = builtins.path {
      path = ./.;
      name = "pgo-script-src";
      filter = path: _: builtins.elem (builtins.baseNameOf path) ["extract-pgo-data.py"];
    };
    inherit (llvmPackages_14) libllvm;
    inherit (linuxPackages) perf;
    inherit pgoDir;

    buildInputs = [pythonWithPkgs pkgsToExtractBuildId];
    nativeBuildInputs = [pythonWithPkgs];
    unpackPhase = "true";
    buildPhase = "${mypy}/bin/mypy --no-color-output $src/extract-pgo-data.py";
    installPhase = ''
      mkdir -p $out/bin
      cp $src/extract-pgo-data.py $out/bin/extract-pgo-data
      substituteInPlace $out/bin/extract-pgo-data \
        --subst-var-by pgoPackagesWithBuildId "${pkgsToExtractBuildId'}" \
        --subst-var    libllvm \
        --subst-var    perf \
        --subst-var    pgoDir \
        --subst-var-by serialisedMappings "$out/serialised.json" \
        --subst-var-by hostname "${nixosPassthru.hostname}"
      python $out/bin/extract-pgo-data --generate $out/serialised.json -j $NIX_BUILD_CORES
      chmod +x $out/bin/extract-pgo-data
    '';
  }
