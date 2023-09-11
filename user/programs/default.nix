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
    ./firefox.nix
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
    chromium = {
      enable = true;
      commandLineArgs = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    };
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
      settings = {
        engine_version = true;
        gpu_name = true;
        vulkan_driver = true;
        wine = true;
      };
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
    gnome.nautilus
    tor-browser-bundle-bin
    wl-clipboard
    xdg-utils
    # jetbrains.idea-community
    pstack
    crc32
    (vencord.override {discord = discord.override {withOpenASAR = true;};})
    virt-manager
    bottles
    (unityhub.override {extraLibs = p: [p.openssl_1_1];})
    jq
    file
    ida
    github-cli
    intel-gpu-tools
  ];
}
