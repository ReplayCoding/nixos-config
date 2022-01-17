{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.myLinuxPackages;
  boot.extraModulePackages = with config.boot.kernelPackages; [ librem-ec-acpi-dkms ];
  boot.initrd.kernelModules = [ "i915" ];

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
}
