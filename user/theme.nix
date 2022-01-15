{ nix-colors, config, pkgs, ... }:

{
  colorscheme = nix-colors.colorSchemes.nord;

  gtk =
    let
      isDark = config.colorscheme.kind == "dark";
      themeName =
        if isDark
        then "Adwaita-dark"
        else "Adwaita";
    in
    {
      enable = true;
      /* theme.package = pkgs.dracula-theme; */
      /* theme.name = "Dracula"; */
      theme.package = pkgs.gnome.gnome-themes-extra;
      theme.name = themeName;
      iconTheme.package = pkgs.gnome.gnome-themes-extra;
      iconTheme.name = themeName;
      gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"${if isDark then "true" else "false"}\"";
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = isDark; };
    };

  xsession.pointerCursor.package = pkgs.gnome.gnome-themes-extra;
  xsession.pointerCursor.name = "Adwaita";
  xsession.pointerCursor.size = 24;
}
