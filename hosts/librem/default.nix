_:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./kernel.nix
    ./ssd.nix
    ./overlays
  ];
}
