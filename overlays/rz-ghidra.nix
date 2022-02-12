{ stdenv
, lib
, fetchFromGitHub
, rizin
, cmake
, meson
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "rz-ghidra";
  inherit (rizin) version;

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = pname;
    rev = "rz-${version}";
    sha256 = "sha256-rCNpTLbS1UkOGULbJUBPNScV7kvB+22vdErTJGEXhvE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [ rizin ] ++ rizin.buildInputs;

  meta = with lib; {
    description = "Deep ghidra decompiler and sleigh disassembler integration for rizin";
    homepage = src.meta.homepage;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
