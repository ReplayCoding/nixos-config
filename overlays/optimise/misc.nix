self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions mesonOptions llvmPackages mkOptions genericOptions fakeExtra makeStatic;
in {
  libarchive-optimised =
    (super.libarchive.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  tmux =
    (super.tmux.overrideAttrs (autotoolsOptions fakeExtra)).override {inherit stdenv;};
  rizin =
    (super.rizin.overrideAttrs (mesonOptions fakeExtra)).override {inherit stdenv;};
}
