{ config, pkgs, lib, ... }:
{
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = false;
    wireless.iwd.settings = {
      General.AddressRandomization = "once";
    };
  };
  systemd.network.networks = {
    "generic" = {
      matchConfig.Name = "*";
      DHCP = "yes";
    };
    "wireless" = {
      matchConfig.Type = "wlan";
      DHCP = "yes";
    };
  };
  boot.kernel.sysctl."net.core.default_qdisc" = "fq_pie";
}
