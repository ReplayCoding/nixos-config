{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        defaultPackage = pkgs.stdenv.mkDerivation {
          pname = "template";
          version = "0.1";

          nativeBuildInputs =
            with pkgs; [
              meson
              pkg-config
              ninja
            ];

          src = ./.;
        };

        devShell = pkgs.mkShell { inputsFrom = [ defaultPackage ]; };
      });
}
