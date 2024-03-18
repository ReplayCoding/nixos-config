_: {
  networking.firewall = rec {
    # Syncthing
    allowedTCPPorts = [22000];
    allowedUDPPorts = [21027];
  };
}
