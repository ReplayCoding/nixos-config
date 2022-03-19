_: {
  networking.firewall = rec {
    # Syncthing
    allowedTCPPorts = [22000];
    allowedUDPPorts = [21027];

    # KDE Connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
