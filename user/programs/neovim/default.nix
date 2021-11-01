{ pkgs, ... }:

let wrappers = import ../../../wrappers { inherit pkgs; };
in
{
  home.packages = [ wrappers.neovim ];
  xdg.configFile."nvim" = {
    source = pkgs.callPackage ./config.nix { };
    recursive = true;
  };
}
