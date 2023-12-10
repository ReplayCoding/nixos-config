_: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 0;
    customPaneNavigationAndResize = true;
    terminal = "screen-256color";
  };
}
