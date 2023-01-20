{
  config,
  nix-colors,
  pkgs,
  lib,
  ...
}: let
  nix-colors-lib = nix-colors.lib-contrib {inherit pkgs;};
  inherit (config.colorscheme) colors;
  inherit (nix-colors-lib) nixWallpaperFromScheme;
in {
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export MOZ_ENABLE_WAYLAND=1
      export NIXOS_OZONE_WL=1
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    config = let
      modifier = "Mod4";
      terminal = "${config.programs.foot.package}/bin/footclient";
    in {
      inherit modifier terminal;
      menu = "${pkgs.fuzzel}/bin/fuzzel -T ${terminal}";
      gaps.inner = 0;
      window.border = 1;
      colors = {
        focused = {
          border = "#${colors.base05}";
          background = "#${colors.base0D}";
          text = "#${colors.base00}";
          indicator = "#${colors.base0D}";
          childBorder = "#${colors.base0D}";
        };
        focusedInactive = {
          border = "#${colors.base01}";
          background = "#${colors.base01}";
          text = "#${colors.base05}";
          indicator = "#${colors.base03}";
          childBorder = "#${colors.base01}";
        };
        unfocused = {
          border = "#${colors.base01}";
          background = "#${colors.base00}";
          text = "#${colors.base05}";
          indicator = "#${colors.base01}";
          childBorder = "#${colors.base01}";
        };
        urgent = {
          border = "#${colors.base08}";
          background = "#${colors.base08}";
          text = "#${colors.base00}";
          indicator = "#${colors.base08}";
          childBorder = "#${colors.base08}";
        };
        placeholder = {
          border = "#${colors.base00}";
          background = "#${colors.base00}";
          text = "#${colors.base05}";
          indicator = "#${colors.base00}";
          childBorder = "#${colors.base00}";
        };
        background = "#${colors.base07}";
      };
      bars = [
        {
          position = "top";
          colors = {
            background = "#${colors.base00}";
            separator = "#${colors.base01}";
            statusline = "#${colors.base04}";

            focusedWorkspace = {
              border = "#${colors.base05}";
              background = "#${colors.base0A}";
              text = "#${colors.base00}";
            };
            activeWorkspace = {
              border = "#${colors.base05}";
              background = "#${colors.base03}";
              text = "#${colors.base00}";
            };
            inactiveWorkspace = {
              border = "#${colors.base03}";
              background = "#${colors.base01}";
              text = "#${colors.base05}";
            };
            urgentWorkspace = {
              border = "#${colors.base08}";
              background = "#${colors.base08}";
              text = "#${colors.base00}";
            };
            bindingMode = {
              border = "#${colors.base00}";
              background = "#${colors.base0A}";
              text = "#${colors.base00}";
            };
          };
          statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = ["JetBrains Mono NL" "Font Awesome 6 Free"];
            size = 10.0;
          };
        }
      ];
      seat = {
        "*" = {
          xcursor_theme = "Adwaita 24";
        };
      };
      keybindings = let
        wobSock = "$XDG_RUNTIME_DIR/wob.sock";
        inherit (pkgs) pamixer brightnessctl playerctl grim slurp gnused systemd;
      in
        lib.mkOptionDefault {
          # for some reason home-manager doesn't bind these keys, so we bind them manually
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          "XF86AudioRaiseVolume" = "exec ${pamixer}/bin/pamixer -ui 2 && ${pamixer}/bin/pamixer --get-volume > ${wobSock}";
          "XF86AudioLowerVolume" = "exec ${pamixer}/bin/pamixer -ud 2 && ${pamixer}/bin/pamixer --get-volume > ${wobSock}";
          "XF86AudioMute" =
            "exec ${pamixer}/bin/pamixer --toggle-mute && "
            + "${pamixer}/bin/pamixer --get-mute && echo 0 > ${wobSock} || ${pamixer}/bin/pamixer --get-volume > ${wobSock}";

          "XF86MonBrightnessDown" = "exec ${brightnessctl}/bin/brightnessctl set -e2 5%- | ${gnused}/bin/sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}";
          "XF86MonBrightnessUp" = "exec ${brightnessctl}/bin/brightnessctl set -e2 +5% | ${gnused}/bin/sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}";

          "XF86AudioPlay" = "exec ${playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${playerctl}/bin/playerctl previous";

          "${modifier}+s" = "exec ${grim}/bin/grim";
          "${modifier}+Shift+s" = "exec ${slurp}/bin/slurp | ${grim}/bin/grim -g -";
          "${modifier}+p" = "exec ${systemd}/bin/loginctl lock-session";
        };
      input."type:pointer".accel_profile = "flat";
      output = {
        "*" = {
          bg = let
            generated = nixWallpaperFromScheme {
              scheme = config.colorscheme;
              width = 1920;
              height = 1080;
              logoScale = 2.0;
            };
          in "${generated} fill";
        };
      };
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "LVDS-1";
        }
        {
          workspace = "2";
          output = "LVDS-1";
        }
        {
          workspace = "3";
          output = "LVDS-1";
        }
        {
          workspace = "4";
          output = "LVDS-1";
        }
        {
          workspace = "5";
          output = "LVDS-1";
        }

        {
          workspace = "6";
          output = "VGA-1";
        }
        {
          workspace = "7";
          output = "VGA-1";
        }
        {
          workspace = "8";
          output = "VGA-1";
        }
        {
          workspace = "9";
          output = "VGA-1";
        }
        {
          workspace = "10";
          output = "VGA-1";
        }
      ];
      window.commands = [
        {
          criteria.app_id = "foot";
          command = "opacity 0.9";
        }
      ];
    };
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
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "${pkgs.systemd}/bin/systemctl start --user swaylock.service";
      }
    ];
  };
  home.file.".swaylock/config".text = "color=000000FF";
}
