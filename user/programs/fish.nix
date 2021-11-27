_:

{
  programs.fish = {
    enable = true;
    shellAliases.cat = "bat";
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
    };
  };
}
