{pkgs, ...}: {
  networking = {
    # broken defaults, my favourite!
    resolvconf.dnsExtensionMechanism = false;

    networkmanager = {
      enable = true;
      wifi = {
        # backend = "iwd";
        macAddress = "preserve";
      };
    };

    firewall.allowedTCPPorts = [];
    firewall.allowedUDPPorts = [];
    firewall.enable = true;
  };

  networking.wireless.scanOnLowSignal = false;
  programs.bandwhich.enable = true;
}
