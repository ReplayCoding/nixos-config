{pkgs, ...}: {
  networking = {
    useDHCP = false;
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        macAddress = "random";
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

    extraHosts = ''
      127.0.0.1 master.pwn3
      127.0.0.1 game.pwn3
    '';
  };

  networking.wireless.scanOnLowSignal = false;
  programs.bandwhich.enable = true;
}
