_: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=7.5, monospace, emoji";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 1.0;
        foreground = "dcdccc";
        background = "111111";

        ## Normal/regular colors (color palette 0-7)
        regular0 = "222222"; # black
        regular1 = "cc9393"; # red
        regular2 = "7f9f7f"; # green
        regular3 = "d0bf8f"; # yellow
        regular4 = "6ca0a3"; # blue
        regular5 = "dc8cc3"; # magenta
        regular6 = "93e0e3"; # cyan
        regular7 = "dcdccc"; # white

        ## Bright colors (color palette 8-15)
        bright0 = "666666"; # bright black
        bright1 = "dca3a3"; # bright red
        bright2 = "bfebbf"; # bright green
        bright3 = "f0dfaf"; # bright yellow
        bright4 = "8cd0d3"; # bright blue
        bright5 = "fcace3"; # bright magenta
        bright6 = "b3ffff"; # bright cyan
        bright7 = "ffffff"; # bright white
      };

      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";
      tweak = {
        grapheme-shaping = "yes";
        grapheme-width-method = "wcswidth";
      };
    };
  };
  systemd.user.services.foot = {
    Unit.X-RestartIfChanged = false;
  };

  xdg.desktopEntries = {
    "footclient" = {
      exec = "";
      name = "Foot Client";
      settings.NoDisplay = "true";
    };
    "foot-server" = {
      exec = "";
      name = "Foot Server";
      settings.NoDisplay = "true";
    };
  };
}
