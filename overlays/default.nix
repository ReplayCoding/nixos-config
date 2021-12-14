{ neovim-nightly-overlay, nixpkgs-wayland, ... }:

{ config, pkgs, lib, ... }:

let inherit (config.nixpkgs) system;
in
{
  imports = [
    {
      nixpkgs.overlays = [
        (self: super: (nixpkgs-wayland.overlay self super) // { inherit (super) i3status-rust; })
        (self: super: neovim-nightly-overlay.overlay self (super // { inherit system; }))
        (self: super: {
          aerc = super.callPackage ./aerc.nix { };
          astronaut = super.callPackage ./astronaut.nix { };
        })
      ];
    }
    ./cmus.nix
    ./fuzzel.nix
    ./fish.nix
    ./bluez.nix
    ./sway.nix
  ];
}
