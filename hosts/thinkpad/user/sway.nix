{ pkgs, ... }:

{
  wayland.windowManager.sway.config = {
    output = {
      "LVDS-1" = {
        resolution = "1366x768";
        pos = "0,0";
      };
      "VGA-1" = {
        mode = "1920x1080@60Hz";
        pos = "1366,0";
      };
    };
  };

  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle manager for Wayland";
      Documentation = "man:swayidle(1)";
      PartOf = "sway-session.target";
    };
    Service = {
      Type = "simple";
      ExecStart =
        let config = pkgs.writeText "swayidle-config" ''
          lock "${pkgs.systemd}/bin/systemctl start --user swaylock.service"
        '';
        in "${pkgs.swayidle}/bin/swayidle -C ${config}";
      RestartSec = 5;
      Restart = "always";
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };

}
