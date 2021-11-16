{ config, pkgs, lib, ... }:
{
  # boot.kernelModules = [ "kvm-amd" "b43" ];
  # boot.blacklistedKernelModules = [ "wl" ];
  # boot.extraModulePackages = [];

  # networking.enableB43Firmware = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  # networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
