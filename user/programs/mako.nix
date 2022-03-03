{ config, pkgs, lib, ... }:

let
  inherit (config.colorscheme) colors;
in
{
  programs.mako = {
    enable = true;
    defaultTimeout = 5000;
    backgroundColor = "#${colors.base00}";
    textColor = "#${colors.base05}";
    borderColor = "#${colors.base01}";
    borderRadius = 3;
  };
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
