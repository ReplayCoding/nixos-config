{ config, pkgs, lib, ... }:
{
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  systemd = {
    # https://bugzilla.redhat.com/show_bug.cgi?id=756787#c9
    services.systemd-networkd-wait-online.serviceConfig.ExecStart = [ "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any" ];
    network.networks = {
      "wired" = {
        matchConfig.PermanentMACAddress = "c4:54:44:6c:b4:d9";
        DHCP = "yes";
      };
      "wireless" = {
        matchConfig.PermanentMACAddress = "b8:ee:65:2c:91:65";
        DHCP = "yes";
      };
    };
  };
}
