{ config, pkgs, lib, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -sd -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -c sway";
      };
    };
  };
}
