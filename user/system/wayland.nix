{ config, pkgs, lib, ... }:

{
  programs.sway.enable = true; # without this, swaylock will not work.
  programs.sway.extraPackages = lib.mkForce [ ];
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    wlr.enable = true;
  };
}
