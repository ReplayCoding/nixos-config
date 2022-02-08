self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv autotoolsOptions mesonOptions llvmPackages genericOptions makeStatic;
in
{
  libarchive-optimised =
    (super.libarchive.overrideAttrs autotoolsOptions).override { inherit stdenv; };
  tmux =
    (super.tmux.overrideAttrs autotoolsOptions).override { inherit stdenv; };
  mesa-optimised =
    (super.mesa.overrideAttrs mesonOptions).override (
      { inherit llvmPackages stdenv; }
      // (super.nixosPassthru.mesaConfig or { })
    );
  tree-sitter-optimised-grammars =
    builtins.map
      (grammar: grammar.overrideAttrs (old: rec {
        CFLAGS = [ "-I${old.src}/src" "-O3" "-flto" ];
        CXXFLAGS = CFLAGS;
      }))
      super.tree-sitter.allGrammars;
  polymc =
    (super.polymc.overrideAttrs genericOptions).override { mkDerivation = super.libsForQt5.mkDerivationWith stdenv.mkDerivation; };
}
