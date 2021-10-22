{ config, pkgs, lib, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Enable zfs
  boot.zfs.forceImportRoot = false;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "7c5b9af1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:
  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";
  services.logind.killUserProcesses = true;
  powerManagement.cpuFreqGovernor = "performance";

  services.logind.extraConfig = ''
    # hibernate when power button is short-pressed
    HandlePowerKey=hibernate
  '';
}
