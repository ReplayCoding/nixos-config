{ pkgs, ... }:

{
  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager = {
      enable = true;
    };

    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];
    firewall.enable = true;
  };

  programs.bandwhich.enable = true;
}
