{ config, pkgs, lib, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.extraModulePackages = lib.mkForce [ ];
  networking.enableB43Firmware = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/sda2";
      preLVM = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;

    opengl.driSupport = true;
    opengl.extraPackages = [ pkgs.vaapiVdpau ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
}
