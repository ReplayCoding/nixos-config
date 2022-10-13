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
    ./fuzzel.nix
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
    dircolors.enable = true;
    bat.enable = true;
    chromium.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    firefox = {
      enable = true;
      package =
        pkgs.librewolf.override {forceWayland = true;};
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [wlrobs];
    };
  };

  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
    syncthing.enable = true;
    easyeffects.enable = true;
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
    # fluffychat
    signal-desktop
    imv
    btop
    amfora
    glow
    nix-tree
    qbittorrent
    libarchive-optimised # bsdtar is amazing
    ccache-stats
    bitwarden-cli
    python39Packages.deemix
    baobab
    aseprite-unfree
    bottles
    gnome.nautilus
    (tor-browser-bundle-bin.override {useHardenedMalloc = false;})
    wl-clipboard
    xdg-utils
    jetbrains.idea-community
    pstack
    (discord.override {withOpenASAR = true;})
  ];
}
