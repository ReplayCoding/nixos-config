_:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./kernel.nix
    ./grub.nix
    ./ssd.nix
    ./power.nix
  ];

  home-manager.users.user = {
    imports = [ ./user ];
  };
}
