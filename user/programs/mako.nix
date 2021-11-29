{ config, pkgs, lib, ... }:

{
  programs.mako.enable = true;
  systemd.user.services.mako = {
    Unit = {
      Description = "Notification daemon for Wayland";
      Documentation = "man:mako(1)";
      PartOf = "sway-session.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mako}/bin/mako";
      RestartSec = 5;
      Restart = "always";
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };
}
