{ neovim-nightly-overlay, nixpkgs-wayland, ... }:

{ config, pkgs, lib, ... }:

let system = config.nixpkgs.system;
in
{
  imports = [
    ./cmus.nix
    ./fuzzel.nix
    ./fish.nix
    ./bluez.nix
  ];
  nixpkgs.overlays = [
    nixpkgs-wayland.overlay
    (self: super: neovim-nightly-overlay.overlay self (super // { inherit system; }))
    (self: super: { aerc = super.pkgs.callPackage ./aerc.nix { }; })
    (self: super: { astronaut = super.pkgs.callPackage ./astronaut.nix { }; })
  ];
}
