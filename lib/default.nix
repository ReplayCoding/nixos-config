{
  pubkeys = import ./pubkeys.nix;
  secrets = import ./secrets.nix;
  sources = super: super.callPackages ./_sources/generated.nix {};
}
