{
  config,
  pkgs,
  lib,
  ...
}: {
  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
