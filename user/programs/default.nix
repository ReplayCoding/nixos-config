{ pkgs, ... }:

{
  imports = [
    ./neovim
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./tmux.nix
    ./starship.nix
    ./rtorrent.nix
    ./i3status-rust.nix
    ./evince.nix
    ./sway.nix
    ./irssi.nix
    ./mako.nix
    ./mpv.nix
    ./spotify.nix
    ./wob.nix
    ./chromium.nix
    ./mail.nix
  ];
  programs = {
    fzf.enable = true;
    lazygit.enable = true;
    taskwarrior.enable = true;
    ssh.enable = true;
    dircolors.enable = true;
    bat.enable = true;

    man = {
      enable = true;
      generateCaches = true;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    croc
    libreoffice
    restic
    yt-dlp
    jellyfin-mpv-shim
    cmus
    picard
    age
    tdesktop
    element-desktop
    signal-desktop
    imv
    btop
    aerc
    astronaut
    python39Packages.deemix
    /* sway */
    wl-clipboard
    xdg-utils
  ];

  services.mpris-proxy.enable = true;
  services.playerctld.enable = true;
  services.syncthing.enable = true;
}
