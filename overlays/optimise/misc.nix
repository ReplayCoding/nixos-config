self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions mesonOptions llvmPackages genericOptions fakeExtra makeStatic;
in {
  libarchive-optimised =
    (super.libarchive.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  tmux =
    (super.tmux.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  tree-sitter-optimised-grammars =
    builtins.map
    (grammar:
      grammar.overrideAttrs (old: rec {
        CFLAGS = ["-I${old.src}/src" "-O3" "-flto"];
        CXXFLAGS = CFLAGS;
      }))
    super.tree-sitter.allGrammars;
  polymc =
    (super.polymc.overrideAttrs (genericOptions fakeExtra)).override {mkDerivation = super.libsForQt5.mkDerivationWith stdenv.mkDerivation;};
  rizin =
    (super.rizin.overrideAttrs (mesonOptions fakeExtra)).override {inherit stdenv;};
}
