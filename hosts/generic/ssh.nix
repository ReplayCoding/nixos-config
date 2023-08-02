_: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  # users.users.root.openssh.authorizedKeys.keys = (import ../../lib/pubkeys.nix).roots;
}
