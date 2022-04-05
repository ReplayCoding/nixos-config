let
  inherit (import ../../lib/pubkeys.nix) all;
in {
  "user-ssh-key.age" = {
    publicKeys = all;
    owner = "user";
  };
}
