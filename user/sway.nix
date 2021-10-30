{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons -run-command \"echo {cmd}\" | ${pkgs.findutils}/bin/xargs ${config.wayland.windowManager.sway.package}/bin/swaymsg exec --";
      gaps.inner = 1;
      window.border = 0;
      bars = [
        {
          position = "top";
          colors = {
            background = "#323232";
            inactiveWorkspace = {
              background = "#323232";
              border = "#323232";
              text = "#5c5c5c";
            };
          };
          statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [ "JetBrains Mono NL" "Font Awesome 5 Free" ];
            size = 10.0;
          };
        }
      ];
      seat = {
        "*" = {
          xcursor_theme = "Adwaita";
          hide_cursor = "when-typing enable";
        };
      };
      keybindings = lib.mkOptionDefault {
        # for some reason home-manager doesn't bind these keys, so we bind them manually
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Shift+0" =
          "move container to workspace number 10";


        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ui 2";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ud 2";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";

        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        "${modifier}+s" = "exec ${pkgs.grim}/bin/grim";
        "${modifier}+Shift+s" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g -";
        "${modifier}+p" = "exec ${pkgs.swaylock}/bin/swaylock";
      };
      output = {
        "*" = {
          bg = "${./background.png} fill";
        };
        "LVDS-1" = {
          resolution = "1366x768";
          pos = "0,0";
        };
        "VGA-1" = {
          mode = "1920x1080@60Hz";
          pos = "1366,0";
        };
      };
      workspaceOutputAssign = [
        { workspace = "1"; output = "LVDS-1"; }
        { workspace = "2"; output = "LVDS-1"; }
        { workspace = "3"; output = "LVDS-1"; }
        { workspace = "4"; output = "LVDS-1"; }
        { workspace = "5"; output = "LVDS-1"; }

        { workspace = "6"; output = "VGA-1"; }
        { workspace = "7"; output = "VGA-1"; }
        { workspace = "8"; output = "VGA-1"; }
        { workspace = "9"; output = "VGA-1"; }
        { workspace = "10"; output = "VGA-1"; }
      ];
      window.commands = [
        { criteria.app_id = "foot"; command = "opacity 0.9"; }
      ];
    };
  };
}
