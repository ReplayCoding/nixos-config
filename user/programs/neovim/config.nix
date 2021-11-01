{ stdenv, gnumake, fennel, findutils, ... }:

stdenv.mkDerivation {
  name = "nvim-config";
  src = ./config;
  nativeBuildInputs = [ gnumake fennel findutils ];
  installPhase = ''
    cp -r . $out
  '';
}
