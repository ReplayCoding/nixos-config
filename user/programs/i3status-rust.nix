_:

{
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      blocks = [
        {
          block = "sound";
          driver = "pulseaudio";
        }
        {
          block = "music";
          player = "cmus";
          format = "{title} ";
          dynamic_width = true;
          hide_when_empty = true;
          marquee = false;
        }
        {
          block = "net";
          format = "{ip} {ssid}";
          interval = 5;
        }
        {
          block = "memory";
          clickable = false;
        }
        {
          block = "cpu";
          interval = 2;
          format = "{barchart} {utilization}";
        }
        {
          block = "time";
          interval = 5;
        }
        {
          block = "battery";
          format = "{percentage} {time}";
        }
      ];
      icons = "awesome5";
      theme = "slick";
    };
  };
}
