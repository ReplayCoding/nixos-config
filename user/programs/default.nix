{ pkgs, ... }:

let wrappers = import ../../wrappers { inherit pkgs; };
in
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
  ];
  programs = {
    fzf.enable = true;
    lazygit.enable = true;
    mako.enable = true;
    taskwarrior.enable = true;
    ssh.enable = true;

    direnv.enable = true;
    direnv.nix-direnv = {
      enable = true;
      enableFlakes = true;
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
    spotify
    cmus
    weechat
    picard
    evince
    age
    /* steam-run */ # Broken as of latest nixpkgs ;; tracker build fails
    tdesktop
    element-desktop
    signal-desktop
    imv
    btop
    python39Packages.deemix
    /* sway */
    wl-clipboard
    xdg-utils
  ];
}
