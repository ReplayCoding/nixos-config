{ pkgs, wrappers }:

{
  foot = import ./foot.nix;
  git = import ./git.nix { inherit pkgs; };
  i3status-rust = import ./i3status-rust.nix;
  rtorrent = import ./rtorrent.nix;
  starship = import ./starship.nix;
  tmux = import ./tmux.nix;

  fzf.enable = true;
  lazygit.enable = true;
  mako.enable = true;
  taskwarrior.enable = true;
  ssh.enable = true;

  fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  direnv.enable = true;
  direnv.nix-direnv = {
    enable = true;
    enableFlakes = true;
  };

  rofi = {
    enable = true;
    terminal = "foot";
  };

  exa = {
    enable = true;
    enableAliases = true;
  };

  chromium = {
    enable = true;
    package = wrappers.chromium { browser = pkgs.ungoogled-chromium; };
  };

  mpv = {
    enable = true;
    package = pkgs.mpv;
  };
}
