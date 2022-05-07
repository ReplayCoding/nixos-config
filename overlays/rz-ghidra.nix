{
  stdenv,
  lib,
  fetchFromGitHub,
  rizin,
  pugixml,
  openssl,
  cmake,
  pkg-config,
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

  buildInputs = [
    rizin
    openssl # required by rizin
    pugixml
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_PUGIXML=ON"
  ];

  meta = with lib; {
    description = "Deep ghidra decompiler and sleigh disassembler integration for rizin";
    inherit (src.meta) homepage;
    license = licenses.lgpl3;
    maintainers = with maintainers; [];
  };
}
