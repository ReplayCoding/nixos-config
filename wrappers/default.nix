{ pkgs }:

rec {
  neovim = pkgs.callPackage ./wrapped_neovim.nix { };
  chromium = pkgs.callPackage ./wrapped_chromium.nix { };
}
