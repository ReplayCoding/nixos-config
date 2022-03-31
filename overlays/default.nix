{
  nixpkgs,
  neovim-nightly-overlay,
  nixpkgs-wayland,
  polymc,
  nix-tree,
  ...
}: let
  fixNixosPassthru = args:
    {
      pgoMode = "off";
      mesaConfig = {};
      ccacheDir = "/var/cache/ccache";
      llvmProfdataDir = "/var/cache/llvm-profdata";
    }
    // args;
  mkOverlay = nixosPassthru':
    nixpkgs.lib.composeManyExtensions [
      (self: super: {
        nixosPassthru = fixNixosPassthru nixosPassthru';
        # This will be used to correlate the pgo results with the derivation it comes from
        pkgsToExtractBuildId = [];
      })
      (self: super: (nixpkgs-wayland.overlay self super) // {inherit (super) i3status-rust;})
      (self: super: neovim-nightly-overlay.overlay self (super // {inherit (super.stdenv.buildPlatform) system;}))
      polymc.overlay
      nix-tree.overlay

      (import ./fuzzel.nix)
      (import ./fish.nix)
      (import ./sway.nix)
      (import ./kernel.nix)

      (self: super: {
        rz-ghidra = super.callPackage ./rz-ghidra.nix {};
        iwd = super.callPackage ./iwd.nix {};
        lutris-unwrapped = super.lutris-unwrapped.override {wine = super.wineWowPackages.stagingFull;};
      })

      (import ./optimise/ccache-stats.nix)
      (import ./optimise/unoptimise-foot.nix)
      (import ./optimise/unsandbox-wob.nix)
      (import ./optimise/misc.nix)
      (import ./optimise/wayland.nix)
      (import ./optimise/mpv.nix)
      (import ./optimise/pipewire.nix)
      (import ./optimise/mesa.nix)
      (import ./optimise/nix.nix)
      (self: super: {extract-pgo-data = super.callPackage ./optimise/pgo {};})
    ];
in {
  inherit mkOverlay;
  overlay = mkOverlay {};
}
