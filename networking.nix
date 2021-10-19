{ config, pkgs, lib, ... }:
{
  # boot.kernelModules = [ "kvm-amd" "b43" ];
  # boot.blacklistedKernelModules = [ "wl" ];
  # boot.extraModulePackages = [];

  # networking.enableB43Firmware = true;
  
  networking.networkmanager = {
    enable = true;
    # wifi.macAddress = "random";
    # wifi.scanRandMacAddress = true;
  };

  networking.networkmanager.insertNameservers = [
      "127.0.0.1"
      "0::1"
  ];

  networking.hostName = "nixos"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  # networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.stubby = {
    enable = true;
    upstreamServers = ''
     # Google
       - address_data: 8.8.8.8
         tls_auth_name: "dns.google"
       - address_data: 8.8.4.4
         tls_auth_name: "dns.google"
       - address_data: 2001:4860:4860::8888
         tls_auth_name: "dns.google"
       - address_data: 2001:4860:4860::8844
         tls_auth_name: "dns.google"
    '';
  };

  hardware.bluetooth.enable = true;

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;
}
