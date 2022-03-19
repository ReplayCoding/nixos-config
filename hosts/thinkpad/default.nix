_: {
  imports = [
    ./kernel.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./power.nix
  ];

  home-manager.users.user = {
    imports = [./user];
  };
}
