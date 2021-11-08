{ neovim-nightly-overlay }:

{ config, pkgs, lib, ... }:

{
  imports = [
    ./cmus.nix
    ./fuzzel.nix
  ];
  nixpkgs.overlays = [
    neovim-nightly-overlay.overlay
  ];
}
