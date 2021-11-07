{ pkgs }:

rec {
  neovim = pkgs.callPackage ./wrapped_neovim.nix { };
}
