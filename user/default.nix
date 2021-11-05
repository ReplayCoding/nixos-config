{ config, pkgs, lib, ... }:

{
  imports = [
    ./system
  ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.user = { pkgs, ... }: {
    imports = [
      ./programs
      ./xdg.nix
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
  };
}
