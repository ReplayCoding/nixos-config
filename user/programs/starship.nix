_: {
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 70;
      add_newline = false;
      character = {
        success_symbol = "[→](bold green)";
        error_symbol = "[→](bold red)";
      };
      battery.disabled = true;
      rust.disabled = true;
    };
  };
}
