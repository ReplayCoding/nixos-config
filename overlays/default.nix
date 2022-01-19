{ neovim-nightly-overlay, nixpkgs-wayland, polymc, ... }:

[
  (self: super: (nixpkgs-wayland.overlay self super) // { inherit (super) i3status-rust; })
  (self: super: neovim-nightly-overlay.overlay self (super // { inherit (super.stdenv.buildPlatform) system; }))
  polymc.overlay

  (import ./fuzzel.nix)
  (import ./fish.nix)
  (import ./bluez.nix)
  (import ./sway.nix)
  (import ./kernel.nix)

  (import ./optimise-mesa.nix)
  (import ./optimise-wayland.nix)
  (import ./optimise-mpv.nix)
  (import ./optimise-pipewire.nix)
  (import ./optimise-libarchive.nix)
]
