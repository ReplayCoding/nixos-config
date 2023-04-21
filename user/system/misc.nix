{
  pkgs,
  config,
  ...
}: {
  programs = {
    dconf.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraLibraries = pkgs:
          with config.hardware.opengl;
            if pkgs.stdenv.hostPlatform.is64bit
            then [package pkgs.libunwind] ++ extraPackages
            else [package32 pkgs.libunwind] ++ extraPackages32;
      };
    };
    fish.enable = true; # Without this, fish doesn't complete man pages
    gamemode.enable = true;
  };
  services.flatpak.enable = true;
}
