{ pkgs, ... }:

{
  gtk = {
    enable = true;
    /* theme.package = pkgs.dracula-theme; */
    /* theme.name = "Dracula"; */
    theme.package = pkgs.gnome.gnome-themes-extra;
    theme.name = "Adwaita";
    iconTheme.package = pkgs.gnome.gnome-themes-extra;
    iconTheme.name = "Adwaita-dark";
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"true\"";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  xsession.pointerCursor.package = pkgs.gnome.gnome-themes-extra;
  xsession.pointerCursor.name = "Adwaita";
  xsession.pointerCursor.size = 24;
}
