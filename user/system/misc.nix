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
            then [package pkgs.libunwind pkgs.gperftools pkgs.noto-fonts-emoji] ++ extraPackages
            else [package32 pkgs.libunwind pkgs.gperftools] ++ extraPackages32;
      };
    };
    fish.enable = true; # Without this, fish doesn't complete man pages
    gamemode.enable = true;
    kdeconnect.enable = true;
  };

  services.flatpak.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    dbus.lib
    fontconfig.lib
    freetype.out
    libgcc.lib
    libglvnd.out
    libxkbcommon.out
    xorg.libX11.out
    xcb-util-cursor.out
    zlib.out
    python3.out
    libxml2.out
    wayland.out
    xorg.xcbutilwm.out
  ];
}
