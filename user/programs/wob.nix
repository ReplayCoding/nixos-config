{pkgs, ...}: {
  systemd.user = {
    services.wob = {
      Unit = {
        Description = "A lightweight overlay volume/backlight/progress/anything bar for Wayland";
        Documentation = "man:wob(1)";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        StandardInput = "socket";
        ExecStart = "${pkgs.wob}/bin/wob";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
    sockets.wob = {
      Socket = {
        ListenFIFO = "%t/wob.sock";
        SocketMode = "0600";
      };
      Install.WantedBy = ["sockets.target"];
    };
  };
}
