{ pkgs, ... }:

{
  networking = {
    hostName = "nixos"; # Define your hostname.
    dhcpcd.enable = false;
    useNetworkd = true;
    wireless.iwd.enable = true;

    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];
    firewall.enable = true;
  };

  systemd.network.enable = true;

  programs.bandwhich.enable = true;
}
