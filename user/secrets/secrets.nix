let
  inherit (import ../../lib/pubkeys.nix) all;
in {
  "work-email-password.age".publicKeys = all;
}
