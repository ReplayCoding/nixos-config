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
    ./kdeconnect.nix
    ./reversing.nix
    ./documentation.nix
    ./ssh.nix
    ./kate.nix
  ];
  programs = {
    fzf.enable = true;
    lazygit.enable = true;
    dircolors.enable = true;
    bat.enable = true;
    neovim.enable = true;
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
        horizontal = true;
        legacy_layout = false;
        table_columns = 20;
        hud_no_margin = true;

        fps = true;
        frametime = true;
        frame_timing = true;
        ram = true;
        debug = false;

        engine_version = true;
        wine = true;
        vulkan_driver = true;
      };
    };

    obs-studio.enable = true;
  };

  services = {
    mpris-proxy.enable = true;
    syncthing.enable = true;
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    croc
    libreoffice-qt
    restic
    yt-dlp
    picard
    age
    tdesktop
    fluffychat
    signal-desktop
    slack
    btop
    amfora
    glow
    nix-tree
    qbittorrent
    libarchive-optimised
    ccache-stats
    bitwarden-cli
    # aseprite-unfree
    tor-browser-bundle-bin
    wl-clipboard
    xdg-utils
    # jetbrains.idea-community
    pstack
    crc32
    vesktop
    virt-manager
    bottles
    # (unityhub.override {extraLibs = p: [p.openssl_1_1];})
    jq
    file
    ida
    blender
    github-cli
    intel-gpu-tools
    konversation
    xwaylandvideobridge
    speedcrunch
    citra-canary
    yuzu
    spirv-cross
    kcachegrind
    valgrind
    graphviz
    linuxPackages.perf
  ];
}
