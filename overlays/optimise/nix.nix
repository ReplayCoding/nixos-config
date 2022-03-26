self: super: let
  inherit (import ./utils.nix super) stdenv genericOptions fakeExtra;
in {
  nix-optimised = super.nixVersions.unstable.overrideAttrs (genericOptions (old: {
    separateDebugInfo = false;
    patches = (old.patches or []) ++ [../patches/nix-5813.patch];
    configureFlags = (old.configureFlags or []) ++ ["--enable-lto"];
  }));
}
