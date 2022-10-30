{pkgs, ...}: {
  networking = {
    useDHCP = false;
    networkmanager = {
      enable = true;
      wifi = {
        # backend = "iwd";
        macAddress = "stable";
      };
    };

    nameservers = [
      # "1.1.1.1#cloudflare-dns.com"
      # "1.0.0.1#cloudflare-dns.com"
      # "2606:4700:4700::1111#cloudflare-dns.com"
      # "2606:4700:4700::1001#cloudflare-dns.com"
    ];

    firewall.allowedTCPPorts = [];
    firewall.allowedUDPPorts = [];
    firewall.enable = true;
  };

  programs.bandwhich.enable = true;

  services.tor = {
    enable = true;
    client.enable = true;
  };
}
