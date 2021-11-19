{ pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ./wrapped_neovim.nix { }) ];
  xdg.configFile."nvim" = {
    source = pkgs.callPackage ./config.nix { };
    recursive = true;
  };
  home.sessionVariables = rec {
    "VISUAL" = "nvim";
    "EDITOR" = VISUAL;
  };
}
