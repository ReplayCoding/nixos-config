_:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=7.5, monospace, emoji";
        dpi-aware = "yes";
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
