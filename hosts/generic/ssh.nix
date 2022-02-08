_:

{
  services.openssh = {
    enable = true;
    openFirewall = false; # openssh is required for agenix to work, but we don't want to have an exponsed ssh service on the network.
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };
}
