_: {
  home.extraOutputsToInstall = ["doc" "devdoc"];
  programs.man = {
    enable = true;
    generateCaches = true;
  };
}
