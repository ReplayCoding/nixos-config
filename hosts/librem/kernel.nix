{ config, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    gfxpayloadBios = "keep";
    device = "/dev/nvme0n1";
  };

  boot.kernelPackages = pkgs.linuxPackages_librem;
  boot.extraModulePackages = with config.boot.kernelPackages; [ librem-ec-acpi-dkms ];
}
