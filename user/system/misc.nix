{
  programs = {
    dconf.enable = true;
    steam.enable = true;
    fish.enable = true; # Without this, fish doesn't complete man pages
    gamemode.enable = true;
  };
  services.flatpak.enable = true;
}
