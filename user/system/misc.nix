{
  pkgs,
  config,
  ...
}: {
  programs = {
    dconf.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
        };
        extraArgs = "-dev -cef-enable-debugging";
        extraLibraries = pkgs:
          with config.hardware.opengl;
            if pkgs.stdenv.hostPlatform.is64bit
            then [package pkgs.libunwind pkgs.gperftools] ++ extraPackages
            else [package32 pkgs.libunwind pkgs.gperftools] ++ extraPackages32;
      };
    };
    fish.enable = true; # Without this, fish doesn't complete man pages
    gamemode.enable = true;
  };
  services.flatpak.enable = true;
}
