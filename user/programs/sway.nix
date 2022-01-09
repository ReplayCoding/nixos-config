{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    config = rec {
      modifier = "Mod4";
      terminal = "${config.programs.foot.package}/bin/footclient";
      menu = "${pkgs.fuzzel}/bin/fuzzel -t f8f8f2ff -b 282a36ff -s 44475aff -S ffffffff -m ff5555ff -r 0 -B 0 --launch-prefix=\"${pkgs.sway}/bin/swaymsg exec --\"";
      gaps.inner = 0;
      window.border = 1;
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
          xcursor_theme = "Adwaita 24";
        };
      };
      keybindings =
        let wobSock = "$XDG_RUNTIME_DIR/wob.sock";
          inherit (pkgs) pamixer brightnessctl playerctl grim slurp gnused systemd;
        in
        lib.mkOptionDefault {
          # for some reason home-manager doesn't bind these keys, so we bind them manually
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+0" =
            "move container to workspace number 10";

          "XF86AudioRaiseVolume" = "exec ${pamixer}/bin/pamixer -ui 2 && ${pamixer}/bin/pamixer --get-volume > ${wobSock}";
          "XF86AudioLowerVolume" = "exec ${pamixer}/bin/pamixer -ud 2 && ${pamixer}/bin/pamixer --get-volume > ${wobSock}";
          "XF86AudioMute" = "exec ${pamixer}/bin/pamixer --toggle-mute && " +
            "${pamixer}/bin/pamixer --get-mute && echo 0 > ${wobSock} || ${pamixer}/bin/pamixer --get-volume > ${wobSock}";

          "XF86MonBrightnessDown" = "exec ${brightnessctl}/bin/brightnessctl set -e2 5%- | ${gnused}/bin/sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}";
          "XF86MonBrightnessUp" = "exec ${brightnessctl}/bin/brightnessctl set -e2 +5% | ${gnused}/bin/sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}";

          "XF86AudioPlay" = "exec ${playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${playerctl}/bin/playerctl previous";

          "${modifier}+s" = "exec ${grim}/bin/grim";
          "${modifier}+Shift+s" = "exec ${slurp}/bin/slurp | ${grim}/bin/grim -g -";
          "${modifier}+p" = "exec ${systemd}/bin/loginctl lock-session";
        };
      output = {
        "*" = {
          bg = "${../background.png} fill";
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

  home.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = 1;
  };

  systemd.user.services = {
    swaylock = {
      Unit = {
        Description = "Screen locker for Wayland";
        Documentation = "man:swaylock(1)";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swaylock}/bin/swaylock";
        Restart = "on-failure";
      };
    };
    swayidle = {
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
  };
  home.file.".swaylock/config".text = "color=000000FF";
}
