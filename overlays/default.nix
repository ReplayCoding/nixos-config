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
        crc32 = super.callPackage ./crc32 {};
        ida = super.callPackage ./ida {};
        lutris-unwrapped = super.lutris-unwrapped.override {wine = super.wineWowPackages.stagingFull;};
        nixpkgs-manual = nixpkgs.htmlDocs.nixpkgsManual;
        kate = super.kate.overrideAttrs (old: {patches = (old.patches or []) ++ [./patches/kate-git-diff-no-ext-diff.patch];});
        picard = super.picard.overrideAttrs (old: {buildInputs = old.buildInputs ++ [self.libsForQt5.kio];});
        citra = super.qt6Packages.callPackage ./citra.nix {};

        glfw3-fixed = super.glfw3.overrideAttrs (old: {
          postPatch = ''
            substituteInPlace src/wl_init.c \
              --replace "libxkbcommon.so.0" "${self.lib.getLib self.libxkbcommon}/lib/libxkbcommon.so.0"

            substituteInPlace src/wl_init.c \
              --replace "libdecor-0.so.0" "${self.lib.getLib self.libdecor}/lib/libdecor-0.so.0"

            substituteInPlace src/wl_init.c \
              --replace "libwayland-client.so.0" "${self.lib.getLib self.wayland}/lib/libwayland-client.so.0"

            substituteInPlace src/wl_init.c \
              --replace "libwayland-cursor.so.0" "${self.lib.getLib self.wayland}/lib/libwayland-cursor.so.0"

            substituteInPlace src/wl_init.c \
              --replace "libwayland-egl.so.1" "${self.lib.getLib self.wayland}/lib/libwayland-egl.so.1"
          '';
        });

        imhex = (super.imhex.override {glfw3 = self.glfw3-fixed;}).overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [self.makeWrapper];
          postInstall =
            old.postInstall
            + ''
              wrapProgram $out/bin/imhex \
                --prefix LD_LIBRARY_PATH : ${self.lib.makeLibraryPath [self.libglvnd]}
            '';
        });
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
