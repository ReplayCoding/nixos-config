{ config, pkgs, lib, ... }:

let myWrappers = import ./wrappers { inherit pkgs; };
in
{
  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.user = { pkgs, ... }: {
    programs = {
      fzf.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      i3status-rust = {
        enable = true;
        bars.default = {
          blocks = [
            {
              block = "music";
              player = "cmus";
              hide_when_empty = true;
            }
            {
              block = "net";
              format = "{ip} {ssid} {speed_up} {speed_down}";
              interval = 5;
            }
            {
              block = "memory";
              clickable = false;
            }
            {
              block = "cpu";
              interval = 2;
              format = "{barchart} {utilization}";
            }
            {
              block = "time";
              interval = 5;
            }
            {
              block = "battery";
              format = "{percentage} {time}";
            }
          ];
          icons = "awesome5";
          theme = "slick";
        };
      };
      taskwarrior.enable = true;

      direnv.enable = true;
      direnv.nix-direnv = {
        enable = true;
        enableFlakes = true;
      };

      ssh.enable = true;

      git = {
        enable = true;
        package = pkgs.gitFull;
        delta.options = {
          line-numbers = true;
        };
        delta.enable = true;
        userName = "ReplayCoding";
        userEmail = "replaycoding@gmail.com";
        includes = [
          {
            contents = {
              sendemail = {
                smtpuser = "replaycoding@gmail.com";
                smtpserver = "smtp.gmail.com";
                smtpencryption = "tls";
                smtpserverport = 587;
              };
            };
          }
        ];
      };

      tmux = {
        enable = true;
        keyMode = "vi";
        escapeTime = 0;
        customPaneNavigationAndResize = true;
        terminal = "screen-256color";
        extraConfig = ''
          set-option -sa terminal-overrides ",foot*:Tc"
        '';
      };

      rtorrent = {
        enable = true;
        settings = "
          session.path.set = ./.rtorrent_session
        ";
      };

      foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font Mono:size=7.5, Noto Sans Mono CJK:size=7.5";
            dpi-aware = "yes";
          };
          mouse = { hide-when-typing = "yes"; };
        };
      };

      rofi = {
        enable = true;
        terminal = "foot";
      };

      starship = {
        enable = true;
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[→](bold green)";
            error_symbol = "[→](bold red)";
          };
          battery.disabled = true;
          rust.disabled = true;
        };
      };
      exa = {
        enable = true;
        enableAliases = true;
      };

      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        autocd = true;
        defaultKeymap = "emacs";
        dotDir = ".config/zsh";
        history.ignorePatterns = [ "ls" "clear" "celar" /* common typo */ ]; # I have a bad habit of spamming these commands
      };

      chromium = {
        enable = true;
        package = myWrappers.chromium { browser = pkgs.ungoogled-chromium; };
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


    home.sessionVariables = {
      "VISUAL" = "nvim";
      "EDITOR" = "nvim";
    };

    services.mpris-proxy.enable = true;
    services.playerctld.enable = true;

    home.file.".swaylock/config".text = "color=000000FF";
    home.file.".local/share/backgrounds/wallpaper.png".source = ./background.png;
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrains Mono NL" ];
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = [ ];
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  programs.steam.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -sd -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -c sway";
      };
    };
  };

  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.enable = false;

  documentation.dev.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
}
