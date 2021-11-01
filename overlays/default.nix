{ neovim-nightly-overlay }:

{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    neovim-nightly-overlay.overlay
  ];
}
