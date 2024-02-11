{
  nixpkgs,
  nixpkgs-master,
  neovim-nightly-overlay,
  prismlauncher,
  ...
} @ inputs: let
  fixNixosPassthru = args:
    nixpkgs.lib.recursiveUpdate
    {
      pgoMode = "off";
      mesaConfig = {};
      ccacheDir = "/var/cache/ccache";
      llvmProfdataDir = "/var/cache/llvm-profdata";
    }
    args;
  fixSystemAlias = overlay: (self: super: let mkSystemAlias = pkgs: {inherit (pkgs.stdenv.hostPlatform) system;} // pkgs; in overlay (mkSystemAlias self) (mkSystemAlias super));
  mkOverlay = nixosPassthru':
    nixpkgs.lib.composeManyExtensions [
      (self: super: {
        nixosPassthru = fixNixosPassthru nixosPassthru';

        mkOverridesFromFlakeInput = input: {
          src = inputs."${input}";
          version = inputs."${input}".rev;
        };
        nixosFlakeInputs = inputs;

        # This will be used to correlate the pgo results with the derivation it comes from
        pkgsToExtractBuildId = [];
      })
      # (fixSystemAlias neovim-nightly-overlay.overlay)
      (fixSystemAlias prismlauncher.overlays.default)

      (import ./fish.nix)
      (import ./kernel.nix)

      (self: super: {
        pstack = super.callPackage ./pstack.nix {};
        crc32 = super.callPackage ./crc32 {};
        ida = super.callPackage ./ida {};
        lutris-unwrapped = super.lutris-unwrapped.override {wine = super.wineWowPackages.stagingFull;};
        nixpkgs-manual = nixpkgs.htmlDocs.nixpkgsManual;
        kate = super.kate.overrideAttrs (old: {patches = (old.patches or []) ++ [./patches/kate-git-diff-no-ext-diff.patch];});
        ghidra = nixpkgs-master.legacyPackages.${super.system}.ghidra;
      })

      (import ./optimise/ccache-stats.nix)
      (import ./optimise/misc.nix)
      # (import ./optimise/mpv.nix)
      (import ./optimise/pipewire.nix)
      (import ./optimise/mesa.nix)

      (self: super: {extract-pgo-data = super.callPackage ./optimise/extract-pgo-data {};})
    ];
in {
  lib = {
    inherit mkOverlay;
    fixOverlayConfig = fixNixosPassthru;
  };
  overlays.default = mkOverlay {};
}
