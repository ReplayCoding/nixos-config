{
  nixpkgs,
  neovim-nightly-overlay,
  nixpkgs-wayland,
  polymc,
  nix-tree,
  ...
}: let
  fixNixosPassthru = args:
    nixpkgs.lib.recursiveUpdate
    {
      pgoMode = "off";
      mesaConfig = {
        driDrivers = [];
      };
      ccacheDir = "/var/cache/ccache";
      llvmProfdataDir = "/var/cache/llvm-profdata";
    }
    args;
  fixSystemAlias = overlay: (self: super: let mkSystemAlias = pkgs: {inherit (pkgs.stdenv.hostPlatform) system;} // pkgs; in overlay (mkSystemAlias self) (mkSystemAlias super));
  mkOverlay = nixosPassthru':
    nixpkgs.lib.composeManyExtensions [
      (self: super: {
        nixosPassthru = fixNixosPassthru nixosPassthru';
        # This will be used to correlate the pgo results with the derivation it comes from
        pkgsToExtractBuildId = [];
      })
      (self: super: (nixpkgs-wayland.overlay self super) // {inherit (super) i3status-rust;})
      (fixSystemAlias neovim-nightly-overlay.overlay)
      (fixSystemAlias polymc.overlay)
      nix-tree.overlay

      (import ./fuzzel.nix)
      (import ./fish.nix)
      (import ./sway.nix)
      (import ./kernel.nix)

      (self: super: {
        rz-ghidra = super.callPackage ./rz-ghidra.nix {};
        lutris-unwrapped = super.lutris-unwrapped.override {wine = super.wineWowPackages.stagingFull;};
        nixpkgs-manual = nixpkgs.htmlDocs.nixpkgsManual;
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
  lib = {
    inherit mkOverlay;
    fixOverlayConfig = fixNixosPassthru;
  };
  overlays.default = mkOverlay {};
}
