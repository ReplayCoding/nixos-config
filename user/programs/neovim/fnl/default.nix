{
  stdenv,
  fennel,
}:
stdenv.mkDerivation {
  name = "neovim-config";
  src = ./.;
  buildPhase = ''
    runHook preBuild
    ${fennel}/bin/fennel --require-as-include --compile init.fnl > init.lua
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp ./init.lua $out/init.lua
    runHook postInstall
  '';
}
