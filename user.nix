{ config, pkgs, lib, ... }:

let myPackages = import ./packages { inherit pkgs; };
in {
  imports =
    [
      <home-manager/nixos>
    ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.user = { pkgs, ... }: {
    programs = {
      fzf.enable = true;
      dircolors.enable = true;
      command-not-found.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      i3status.enable = true;
      
      direnv.enable = true;
      direnv.nix-direnv = {
        enable = true;
        enableFlakes = true;
      };

      ssh.enable = true;

      git = {
        enable = true;
        userName = "user";
        userEmail = "user@nixos";
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
          mouse = {hide-when-typing = "yes";};
        };
      };

      rofi = {
        enable = true;
      };
      

      zsh = {
        enable = true;
	enableAutosuggestions = true;
	enableCompletion = true;
	autocd = true;
	defaultKeymap = "emacs";
	dotDir = ".config/zsh";
	localVariables = {
          "PROMPT" = "%? (%n@%m) %B%d%b $ ";
	};
	envExtra = ''
          alias ls="ls --color=auto"
	'';
	plugins = [
	  {
	    name = "zsh-syntax-highlighting";
	    src = pkgs.fetchFromGitHub {
	      owner = "zsh-users";
	      repo = "zsh-syntax-highlighting";
	      rev = "0.7.1";
	      sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
	    };
	  }
	];
      };

      htop = {
        enable = true;
	settings = {
	  show_cpu_usage = true;
	};
      };

      chromium = {
        enable = true;
	package = myPackages.wrap-chromium { browser = pkgs.ungoogled-chromium; };
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
      rclone
      wineWowPackages.stable
      # sc-im
      yt-dlp
      jellyfin-media-player
      /* tor-browser-bundle-bin # security critical application, so we need the latest version # is currently broken */
      spotify
      ghidra-bin
      cmus
      weechat
      picard
      evince
      age
      niv
      /* steam-run */ # Broken as of latest nixpkgs ;; tracker build fails
      tdesktop
      /* sway */
      swaylock
      brightnessctl
      playerctl
      grim
      wl-clipboard
      slurp
      wob
      pamixer
      /* ---- */
      myPackages.deemix
      myPackages.wrapped-nnn
      myPackages.wrapped-neovim
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
    };
    
    services.mpris-proxy.enable = true;
    services.playerctld.enable = true;
    /* services.lorri.enable = true; */ # Not required for flakes anymore!!

    home.file.".swaylock/config".text = "color=000000FF";
    home.file.".local/share/backgrounds/wallpaper.png".source = ./background.png;
    xdg.configFile."nnn/plugins".source = builtins.concatStringsSep "/" [
      ( builtins.fetchTarball {
            url = "https://github.com/jarun/nnn/releases/download/v4.2/nnn-v4.2.tar.gz";
            sha256 = "18nwy44a0lddzxgs42xlgcdxv90kal6qlnfwrz1vrcb1nby0a990"; } )
      "plugins"
    ];
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrains Mono NL"];
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [];
    extraSessionCommands = ''
    export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
  };

  programs.dconf.enable = true; 

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
      };
    };
  };

  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.enable = false;

  security.chromiumSuidSandbox.enable = true;

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
