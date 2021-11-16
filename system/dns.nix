_:

{
  networking.networkmanager.insertNameservers = [
    "127.0.0.1"
    "0::1"
  ];

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
}
