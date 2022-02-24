{ stdenv
, python3
, llvmPackages_13
, pkgsToExtractBuildId
, nixosPassthru
, pgoDir ? null # Needs to be set
}:

let
  pkgsWithAllOutputs = pkgs: builtins.concatMap (pkg: builtins.map (output: pkg.${output}) pkg.outputs) pkgs;
  pkgsToExtractBuildId' = builtins.concatStringsSep "\n" (builtins.map (e: toString e) (pkgsWithAllOutputs pkgsToExtractBuildId));
in
stdenv.mkDerivation {
  name = "pgo-script";
  src = ./.;
  inherit (llvmPackages_13) libllvm;
  inherit pgoDir;

  buildInputs = [ python3 pkgsToExtractBuildId ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp $src/extract-pgo-data $out/bin
    substituteInPlace $out/bin/extract-pgo-data \
      --subst-var-by pgoPackagesWithBuildId "${pkgsToExtractBuildId'}" \
      --subst-var    libllvm \
      --subst-var    pgoDir \
      --subst-var-by hostname "${nixosPassthru.hostname}"
    chmod +x $out/bin/extract-pgo-data
  '';
}
