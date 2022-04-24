{
  config,
  nix-colors,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    launch-prefix = ${pkgs.sway}/bin/swaymsg exec --

    [colors]
    text = ${colors.base05}ff
    background = ${colors.base00}ff
    selection = ${colors.base03}ff
    selection-text = ${colors.base05}ff
    match = ${colors.base0A}ff

    [border]
    radius = 3
    width = 0
  '';
}
