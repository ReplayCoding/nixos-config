{ pkgs, ... }:

{
  xsession.pointerCursor = {
    package = pkgs.gnome.gnome-themes-extra;
    name = "Adwaita";
    size = 24;
  };
}
