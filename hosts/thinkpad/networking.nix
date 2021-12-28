{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "thinkpad";
    hostId = "7c5b9af1";
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
}
