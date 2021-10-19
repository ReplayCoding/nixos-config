{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs }: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./core.nix
          ./kernel.nix
          ./hardware-configuration.nix

          ./sound.nix
          ./mediapiracy.nix
          ./networking.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
          }
          ./user.nix
        ];
    };
  };
}
