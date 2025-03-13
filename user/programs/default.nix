{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./tmux.nix
    ./starship.nix
    ./firefox.nix
    ./irssi.nix
    ./mpv.nix
    ./spotify.nix
    ./cmus.nix
    ./reversing.nix
    ./documentation.nix
    ./ssh.nix
    ./vscode.nix
  ];
  programs = {
    ripgrep.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    dircolors.enable = true;
    bat.enable = true;
    neovim.enable = true;
    chromium = {
      enable = true;
      package = pkgs.chromium.override {enableWideVine = true;};
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
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
    fd
    croc
    libreoffice-qt
    restic
    yt-dlp
    # picard
    tdesktop
    signal-desktop
    btop
    glow
    nix-tree
    qbittorrent
    libarchive
    # ccache-stats
    # aseprite-unfree
    tor-browser-bundle-bin
    wl-clipboard
    xdg-utils
    # jetbrains.idea-community
    crc32
    vesktop
    virt-manager
    # (unityhub.override {extraLibs = p: [p.openssl_1_1];})
    jq
    file
    ida
    # blender
    github-cli
    intel-gpu-tools
    speedcrunch
    # lime3ds TODO
    # yuzu
    valgrind
    graphviz
    linuxPackages.perf
    hotspot
    toolbox
    zeal
    p7zip
    unrar
    thunderbird
    kdePackages.filelight
    wireshark
    # prismlauncher
    bubblewrap
    newsflash
    heroic
    jdk23
    zig
    bottles
  ];
}
