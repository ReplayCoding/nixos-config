{
  enable = true;
  bars.default = {
    blocks = [
      {
        block = "music";
        player = "cmus";
        hide_when_empty = true;
      }
      {
        block = "net";
        format = "{ip} {ssid} {speed_up} {speed_down}";
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
}
