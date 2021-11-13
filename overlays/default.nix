{ neovim-nightly-overlay, nixpkgs-wayland, ... }:

{ config, pkgs, lib, ... }:

{
  imports = [
    ./cmus.nix
    ./fuzzel.nix
  ];
  nixpkgs.overlays = [
    neovim-nightly-overlay.overlay
    nixpkgs-wayland.overlay
    (self: super: { aerc = super.pkgs.callPackage ./aerc.nix { }; })
  ];
}
