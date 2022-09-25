{
  config,
  pkgs,
  lib,
  ...
}: {
  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
  environment.systemPackages = [pkgs.qt5.qtwayland];
}
