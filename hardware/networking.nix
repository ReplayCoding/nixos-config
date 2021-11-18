{ config, pkgs, lib, ... }:
{
  boot.kernelModules = [ "b43" ];
  boot.blacklistedKernelModules = [ "wl" ];
  boot.extraModulePackages = lib.mkForce [ ];

  networking.enableB43Firmware = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
}
