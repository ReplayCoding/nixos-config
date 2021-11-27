_:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "monospace:size=7.5, emoji";
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
}
