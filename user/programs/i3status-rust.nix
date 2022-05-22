{config, ...}: let
  makeMusicBlock = player: {
    inherit player;
    block = "music";
    format = "{title} ";
    dynamic_width = true;
    hide_when_empty = true;
    marquee = false;
  };
in {
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
          format = "{ip} ({signal_strength})";
          interval = 5;
        }
        {
          block = "memory";
          format_mem = "{mem_used;M}/{mem_total;M}({mem_used_percents})";
          clickable = false;
        }
        {
          block = "temperature";
          collapsed = false;
        }
        {block = "load";}
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
          driver = "upower";
          format = "{percentage} {time}";
        }
      ];
      icons = "awesome6";
      settings.theme = let
        inherit (config.colorscheme) colors;
      in {
        name = "slick";
        overrides = {
          idle_bg = "#${colors.base00}";
          idle_fg = "#${colors.base05}";
          info_bg = "#${colors.base0C}";
          info_fg = "#${colors.base00}";
          good_bg = "#${colors.base0B}";
          good_fg = "#${colors.base00}";
          warning_bg = "#${colors.base0A}";
          warning_fg = "#${colors.base00}";
          critical_bg = "#${colors.base08}";
          critical_fg = "#${colors.base00}";
        };
      };
    };
  };
  xdg.configFile."i3status-rust/config-default.toml".onChange = config.xdg.configFile."sway/config".onChange;
}
