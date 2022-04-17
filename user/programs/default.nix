{pkgs, ...}: {
  imports = [
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
    ./polkit.nix
    ./wlsunset.nix
    ./cmus.nix
    ./kdeconnect.nix
    ./reversing.nix
    ./documentation.nix
    ./ssh.nix
    ./neovim
  ];
  programs = {
    fzf.enable = true;
    lazygit.enable = true;
    taskwarrior.enable = true;
    dircolors.enable = true;
    bat.enable = true;
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
    firefox = {
      enable = true;
      package =
        pkgs.librewolf.override {forceWayland = true;};
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
    picard
    age
    polymc
    tdesktop
    fluffychat
    signal-desktop
    imv
    btop
    amfora
    glow
    nix-tree
    qbittorrent
    libarchive-optimised # bsdtar is amazing
    ccache-stats
    lutris
    bitwarden-cli
    python39Packages.deemix
    /*
     sway
     */
    wl-clipboard
    xdg-utils
  ];

  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
    syncthing.enable = true;
    easyeffects.enable = true;
  };
}
