{ pkgs }:

rec {
  deezer-py = pkgs.callPackage ./deezer_py.nix {};
  spotipy = pkgs.callPackage ./spotipy.nix {};
  deemix = pkgs.callPackage ./deemix.nix { inherit deezer-py spotipy; }; 

  wrapped-nnn = pkgs.callPackage ./wrapped_nnn.nix {};
  wrapped-neovim = pkgs.callPackage ./wrapped_neovim.nix {};
  wrap-chromium = pkgs.callPackage ./wrapped_chromium.nix {};
}
