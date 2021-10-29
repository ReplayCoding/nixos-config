{ config, pkgs, lib, ... }:

let myWrappers = import ../wrappers { inherit pkgs; };
in
{
  imports = [
    ./x11.nix
    ./wayland.nix
    ./fonts.nix
    ./misc.nix
  ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.user = { pkgs, ... }: {
    programs = (import ./programs/default.nix { inherit pkgs; wrappers = myWrappers; });

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
      /* sway */
      swaylock
      brightnessctl
      playerctl
      grim
      wl-clipboard
      slurp
      wob
      pamixer
      xdg-utils
      /* ---- */
      python39Packages.deemix
      myWrappers.neovim
    ];


    home.sessionVariables = rec {
      "VISUAL" = "nvim";
      "EDITOR" = VISUAL;
    };

    services.mpris-proxy.enable = true;
    services.playerctld.enable = true;
    gtk = {
      enable = true;
      /* theme.package = pkgs.dracula-theme; */
      /* theme.name = "Dracula"; */
      theme.package = pkgs.gnome.adwaita-icon-theme;
      theme.name = "Adwaita";
      iconTheme.package = pkgs.gnome.adwaita-icon-theme;
      iconTheme.name = "Adwaita-dark";
      gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"true\"";
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
    };

    xsession.pointerCursor.package = pkgs.gnome.adwaita-icon-theme;
    xsession.pointerCursor.name = "Adwaita";

    home.file.".swaylock/config".text = "color=000000FF";
    home.file.".local/share/backgrounds/wallpaper.png".source = ./background.png;
  };
}
