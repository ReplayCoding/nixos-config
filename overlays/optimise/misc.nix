self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions mesonOptions llvmPackages mkOptions genericOptions fakeExtra makeStatic;
in {
  libarchive-optimised =
    (super.libarchive.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  tmux =
    (super.tmux.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
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
