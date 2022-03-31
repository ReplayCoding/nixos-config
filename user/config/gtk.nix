{
  nix-colors,
  config,
  pkgs,
  ...
}: let
  nix-colors-lib = nix-colors.lib {inherit pkgs;};
  inherit (nix-colors-lib) gtkThemeFromScheme;
in {
  gtk = let
    isDark = config.colorscheme.kind == "dark";
  in {
    enable = true;
    theme.name = "Adwaita";
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"${
      if isDark
      then "true"
      else "false"
    }\"";
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = isDark;};
    cursorTheme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita";
      size = 24;
    };
  };
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @define-color accent_bg_color @purple_3;
    @define-color accent_color #{if($variant == 'dark', "@purple_2", "@purple_4")};
  '';
}
