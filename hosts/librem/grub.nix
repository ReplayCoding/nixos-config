{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-colors-lib = inputs.nix-colors.lib-contrib {inherit pkgs;};
  inherit (config.home-manager.users.user) colorscheme;
  inherit (colorscheme) colors;
  inherit (nix-colors-lib) nixWallpaperFromScheme;
in {
  boot.loader.grub = {
    enable = true;
    version = 2;
    gfxpayloadBios = "keep";
    gfxmodeBios = "1280x720";
    font = "${pkgs.cozette}/share/fonts/misc/cozette.bdf";
    splashImage = nixWallpaperFromScheme {
      scheme = colorscheme;
      width = 1280;
      height = 720;
      logoScale = 2.0;
    };
    device = "/dev/disk/by-id/nvme-eui.0025385711903f71";
  };
}
