{ pkgs, ... }:

{
  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    useNetworkd = true;
    wireless.iwd = {
      enable = true;
      settings = {
        General.AddressRandomization = "once";
      };
    };

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
  boot.kernel.sysctl."net.core.default_qdisc" = "fq_pie";
}
