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
        {
          block = "bluetooth";
          mac = "4C:87:5D:6B:72:B1";
          hide_disconnected = true;
          format = "{percentage}";
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
          format_mem = "{mem_used;M}/{mem_total;M}({mem_used_percents})";
          clickable = false;
        }
        { block = "load"; }
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
