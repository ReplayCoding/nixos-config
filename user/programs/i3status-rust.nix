_:

let makeMusicBlock = player: {
  inherit player;
  block = "music";
  format = "{title} ";
  dynamic_width = true;
  hide_when_empty = true;
  marquee = false;
};
in
{
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      blocks = [
        {
          block = "sound";
          driver = "pulseaudio";
        }
        (makeMusicBlock "cmus")
        (makeMusicBlock "ncspot")
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
