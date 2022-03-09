{ nixpkgs, neovim-nightly-overlay, nixpkgs-wayland, polymc, nix-tree, ... }:

nixosPassthru:

nixpkgs.lib.composeManyExtensions [
  (self: super: {
    inherit nixosPassthru;
    # This will be used to correlate the pgo results with the derivation it comes from
    pkgsToExtractBuildId = [ ];
  })
  (self: super: (nixpkgs-wayland.overlay self super) // { inherit (super) i3status-rust; })
  (self: super: neovim-nightly-overlay.overlay self (super // { inherit (super.stdenv.buildPlatform) system; }))
  polymc.overlay
  nix-tree.overlay

  (import ./fuzzel.nix)
  (import ./fish.nix)
  (import ./sway.nix)
  (import ./kernel.nix)
  (import ./ccache-stats.nix)

  (self: super: {
    rz-ghidra = super.callPackage ./rz-ghidra.nix { };
    iwd = super.callPackage ./iwd.nix { };
  })

  (import ./unoptimise-foot.nix)
  (import ./optimise-misc.nix)
  (import ./optimise-wayland.nix)
  (import ./optimise-mpv.nix)
  (import ./optimise-pipewire.nix)
  (import ./optimise-mesa.nix)

  (self: super: { extract-pgo-data = super.callPackage ./pgo { }; })
]
