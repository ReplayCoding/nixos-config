{ neovim-nightly-overlay }:

{ config, pkgs, lib, ... }:

{
  imports = [
    ./cmus.nix
  ];
  nixpkgs.overlays = [
    neovim-nightly-overlay.overlay
  ];
}
