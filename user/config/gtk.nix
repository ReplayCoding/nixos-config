{ nix-colors, config, pkgs, ... }:

let
  nix-colors-lib = nix-colors.lib { inherit pkgs; };
  inherit (nix-colors-lib) gtkThemeFromScheme;
in
{
  gtk =
    let
      isDark = config.colorscheme.kind == "dark";
      themePackage = gtkThemeFromScheme { scheme = config.colorscheme; };
      themeName = config.colorscheme.slug;
    in
    {
      enable = true;
      theme.package = themePackage;
      theme.name = themeName;
      iconTheme.package = themePackage;
      iconTheme.name = themeName;
      gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"${if isDark then "true" else "false"}\"";
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = isDark; };
    };
}
