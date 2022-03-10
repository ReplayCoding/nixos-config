_:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };
  users.users.root.openssh.authorizedKeys.keys = (import ../../lib/pubkeys.nix).roots;
}
