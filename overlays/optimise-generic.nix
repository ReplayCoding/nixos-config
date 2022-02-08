self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv mesonOptions llvmPackages genericOptions makeStatic;
  # FIXME: move autotools stuff to optimise-utils
  flags = "-flto=thin -O3";
in
{
  libarchive-optimised =
    (super.libarchive.overrideAttrs (old: rec {
      CFLAGS = (old.CFLAGS or "") + flags;
      LDFLAGS = (old.LDFLAGS or "") + flags;
      makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
    } // genericOptions old)).override { inherit stdenv; };
  tmux =
    (super.tmux.overrideAttrs (old: rec {
      CFLAGS = (old.CFLAGS or "") + flags;
      LDFLAGS = (old.LDFLAGS or "") + flags;
      makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
    } // genericOptions old)).override { inherit stdenv; };
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
    (super.polymc.overrideAttrs genericOptions)
    .override { mkDerivation = super.libsForQt5.mkDerivationWith stdenv.mkDerivation; };
}
