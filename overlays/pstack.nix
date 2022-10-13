{
  stdenv,
  cmake,
  xz,
  zlib,
  mkOverridesFromFlakeInput,
}:
stdenv.mkDerivation {
  pname = "pstack";
  inherit (mkOverridesFromFlakeInput "pstack") version src;

  nativeBuildInputs = [cmake];
  buildInputs = [xz zlib];
}
