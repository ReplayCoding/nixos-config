{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, home-manager, neovim-nightly-overlay, nixpkgs-wayland, flake-utils, pre-commit-hooks }@inputs: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ({ lib, ... }: {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = lib.mkForce [ "nixpkgs=${nixpkgs}" ];
          })
          (import ./overlays inputs)
          ./hardware
          ./system
          ./containers
          agenix.nixosModules.age
          home-manager.nixosModules.home-manager
          { home-manager.useGlobalPkgs = true; }
          ./user
        ];
    };
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages."${system}";
      pre-commit-check = pre-commit-hooks.lib."${system}".run {
        src = ./.;
        hooks = {
          nixpkgs-fmt.enable = true;
        };
      };
    in
    {
      devShell = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
        packages = with pkgs; [ statix agenix.defaultPackage."${system}" ];
      };
    });
}
