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
  ];
  programs = {
    fzf.enable = true;
    lazygit.enable = true;
    taskwarrior.enable = true;
    ssh.enable = true;
    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
    };

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
    jellyfin-media-player
    /* tor-browser-bundle-bin # security critical application, so we need the latest version # is currently broken */
    cmus
    picard
    age
    /* steam-run */ # Broken as of latest nixpkgs ;; tracker build fails
    tdesktop
    element-desktop
    signal-desktop
    imv
    btop
    aerc
    python39Packages.deemix
    /* sway */
    wl-clipboard
    xdg-utils
  ];

  services.mpris-proxy.enable = true;
  services.playerctld.enable = true;
}
