{ config, pkgs, lib, ... }:
{
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  systemd.network.networks = {
    "wired" = {
      matchConfig.PermanentMACAddress = "c4:54:44:6c:b4:d9";
      DHCP = "yes";
    };
    "wireless" = {
      matchConfig.PermanentMACAddress = "b8:ee:65:2c:91:65";
      DHCP = "yes";
    };
  };
  boot.kernel.sysctl."net.core.default_qdisc" = "fq_pie";
}
