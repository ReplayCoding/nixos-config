_:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./kernel.nix
    ./ssd.nix
    ./power.nix
    ./overlays
  ];

  home-manager.users.user = {
    imports = [ ./user ];
  };
}
