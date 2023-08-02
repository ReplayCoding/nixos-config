self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions mesonOptions llvmPackages genericOptions fakeExtra makeStatic;
in {
  libarchive-optimised =
    (super.libarchive.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  tmux =
    (super.tmux.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  tree-sitter-optimised-grammars =
    builtins.map
    (
      grammar:
        grammar.overrideAttrs (old: rec {
          CFLAGS = ["-I${old.src}/src" "-O3" "-flto"];
          CXXFLAGS = CFLAGS;
        })
    )
    (with super.tree-sitter.builtGrammars; [
      tree-sitter-c
      tree-sitter-cmake
      tree-sitter-fennel
      tree-sitter-comment
      tree-sitter-cpp
      tree-sitter-dot
      tree-sitter-fish
      tree-sitter-glsl
      tree-sitter-go
      tree-sitter-json
      tree-sitter-julia
      tree-sitter-kotlin
      tree-sitter-lua
      tree-sitter-nix
      tree-sitter-python
      tree-sitter-rust
      tree-sitter-toml
      tree-sitter-zig
    ]);
  rizin =
    (super.rizin.overrideAttrs (mesonOptions fakeExtra)).override {inherit stdenv;};
}
