self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv mesonOptions llvmPackages genericOptions makeStatic;
in
{
  libarchive-optimised =
    let
      flags = "-flto=thin -O3";
    in
    (super.libarchive.overrideAttrs (old: rec {
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
}