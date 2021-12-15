{ pkgs, ... }:

{
  networking = {
    hostName = "nixos"; # Define your hostname.
    dhcpcd.enable = false;
    useNetworkd = true;
    wireless.iwd.enable = true;

    nameservers = [
      # "1.1.1.1#cloudflare-dns.com"
      # "1.0.0.1#cloudflare-dns.com"
      # "2606:4700:4700::1111#cloudflare-dns.com"
      # "2606:4700:4700::1001#cloudflare-dns.com"
    ];

    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];
    firewall.enable = true;
  };

  systemd = {
    network.enable = true;
    services.systemd-networkd-wait-online.enable = false;
  };
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNSOverTLS=opportunistic
    '';
  };

  programs.bandwhich.enable = true;
}
