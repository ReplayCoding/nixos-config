{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, flake-utils }: {

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
          { home-manager.useGlobalPkgs = true; }
          {
            nix.binaryCaches = [ "https://nix-community.cachix.org" ];
            nix.binaryCachePublicKeys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
            nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
          }
          ./user.nix
          { system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev; }
        ];
    };
  } // flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        packages = with pkgs; [ nixpkgs-fmt ];
      };
    });
}
