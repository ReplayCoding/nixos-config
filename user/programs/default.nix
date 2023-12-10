{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./tmux.nix
    ./starship.nix
    ./firefox.nix
    ./rtorrent.nix
    ./irssi.nix
    ./mpv.nix
    ./spotify.nix
    ./cmus.nix
    # ./kdeconnect.nix
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
    eza = {
      enable = true;
      enableAliases = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    mangohud = {
      enable = true;
      settings = {
        engine_version = true;
        gpu_name = true;
        vulkan_driver = true;
        wine = true;
      };
    };

    obs-studio.enable = true;
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
    prismlauncher
    tdesktop
    fluffychat
    signal-desktop
    slack
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
    # aseprite-unfree
    tor-browser-bundle-bin
    wl-clipboard
    xdg-utils
    # jetbrains.idea-community
    pstack
    crc32
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    virt-manager
    bottles
    # (unityhub.override {extraLibs = p: [p.openssl_1_1];})
    jq
    file
    ida
    github-cli
    intel-gpu-tools
  ];
}
