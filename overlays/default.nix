{ neovim-nightly-overlay, nixpkgs-wayland, ... }:

{ config, pkgs, lib, ... }:

let inherit (config.nixpkgs) system;
in
{
  nixpkgs.overlays = [
    (self: super: (nixpkgs-wayland.overlay self super) // { inherit (super) i3status-rust; })
    (self: super: neovim-nightly-overlay.overlay self (super // { inherit system; }))

    (import ./fuzzel.nix)
    (import ./fish.nix)
    (import ./bluez.nix)
    (import ./sway.nix)
    (import ./optimise-wayland.nix)
    (import ./optimise-mpv.nix)
    (import ./optimise-pipewire.nix)

    (self: super: {
      aerc = super.callPackage ./aerc.nix { };
      astronaut = super.callPackage ./astronaut.nix { };
    })
  ];
}
