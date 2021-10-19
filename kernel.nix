{ config, pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/hardened.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1" "init_on_free=1"
    "page_alloc.shuffle=1"
    "vsyscall=none"
    "debugfs=off"
  ];

  environment.memoryAllocator.provider = "libc";
  security.lockKernelModules = false;
  security.protectKernelImage = false;
  security.apparmor.enable = false; # FIXME! only disabled because transmission is currently broken on it. wait for nixpkgs fix
  security.apparmor.killUnconfinedConfinables = false;

  security.unprivilegedUsernsClone = true;

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
  boot.supportedFilesystems = ["zfs"];
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
