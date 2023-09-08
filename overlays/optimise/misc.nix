self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions mesonOptions llvmPackages mkOptions genericOptions fakeExtra makeStatic;
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
      # tree-sitter-zig
    ]);
  rizin =
    (super.rizin.overrideAttrs (mesonOptions fakeExtra)).override {inherit stdenv;};

  ghidra = super.ghidra.overrideAttrs (old':
    mkOptions {
      old = old';
      layers = [
        (genericOptions fakeExtra)
        (old: {
          env.NIX_CFLAGS_COMPILE =
            toString (old.env.NIX_CFLAGS_COMPILE or "") + " -flto"; # host platform
          env.NIX_CFLAGS_COMPILE_FOR_TARGET =
            toString (old.env.NIX_CFLAGS_COMPILE_FOR_TARGET or "") + " -flto";
        })
      ];
    });
}
