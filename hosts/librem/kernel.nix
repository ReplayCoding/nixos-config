{ config, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    gfxpayloadBios = "keep";
    device = "/dev/disk/by-id/nvme-eui.0025385711903f71";
  };

  boot.kernelPackages = pkgs.linuxPackages_librem;
  boot.extraModulePackages = with config.boot.kernelPackages; [ librem-ec-acpi-dkms ];
  boot.initrd.kernelModules = [ "i915" ];

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
}
