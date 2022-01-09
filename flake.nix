{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
    ragenix.url = "github:yaxitech/ragenix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ragenix, home-manager, neovim-nightly-overlay, nixpkgs-wayland, flake-utils, pre-commit-hooks }@inputs:
    let
      specialArgs = { inherit (inputs) neovim-nightly-overlay nixpkgs-wayland; };
      generic = [
        ({ lib, ... }: {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.nixPath = lib.mkForce [ "nixpkgs=${nixpkgs}" ];
        })
        ./overlays
        ./hosts/generic
        ./containers
        ragenix.nixosModules.age
        home-manager.nixosModules.home-manager
        { home-manager.useGlobalPkgs = true; }
        ./user
      ];
    in
    {

      nixosConfigurations = {
        librem = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/librem ] ++ generic;
          inherit specialArgs;
        };
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/thinkpad ] ++ generic;
          inherit specialArgs;
        };
      };

      templates = {
        "meson".path = ./templates/meson;
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
          packages = with pkgs; [ statix ragenix.defaultPackage."${system}" fnlfmt ];
        };
      });
}
