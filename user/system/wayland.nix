{ config, pkgs, lib, ... }:

{
  programs.sway.enable = true; # without this, swaylock will not work.
  programs.sway.extraPackages = lib.mkForce [ ];
  xdg.portal.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -sd -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -c sway";
      };
    };
  };
}