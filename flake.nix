rec {
  description = "NixOS configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dav1d = {
    #   url = "git+https://code.videolan.org/videolan/dav1d";
    #   flake = false;
    # };
    # libplacebo = {
    #   url = "git+https://code.videolan.org/videolan/libplacebo?submodules=1";
    #   flake = false;
    # };
    # mpv = {
    #   url = "github:mpv-player/mpv";
    #   flake = false;
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    pre-commit-hooks,
    ...
  } @ inputs: let
    allowedSystems = ["x86_64-linux" "aarch64-linux"];
    forSystems = nixpkgs.lib.genAttrs allowedSystems;
    recursiveMerge = l: builtins.foldl' (nixpkgs.lib.recursiveUpdate) {} l;
    mkHost = {
      system,
      modules,
      hostname,
      overlayConfig ? {},
    }: let
      overlayConfig' = overlayConfig // {inherit hostname;};
      specialArgs = {
        flib = self.lib;
        inherit nixConfig inputs;
      };
    in {
      overlayConfig.${hostname} = self.lib.fixOverlayConfig overlayConfig';
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            ({lib, ...}: {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              nixpkgs.overlays = [(self.lib.mkOverlay overlayConfig')];
            })
            ./hosts/generic
            home-manager.nixosModules.home-manager
            {home-manager.useGlobalPkgs = true;}
            ./user
          ]
          ++ modules;
      };
    };
  in
    recursiveMerge [
      (
        recursiveMerge
        (
          builtins.map mkHost [
            {
              system = "x86_64-linux";
              hostname = "librem";
              modules = [./hosts/librem];
              overlayConfig = {
              };
            }
            {
              system = "x86_64-linux";
              hostname = "thinkpad";
              modules = [./hosts/thinkpad];
              overlayConfig = {
              };
            }
          ]
        )
      )
      {
        devShells = forSystems (system: let
          pkgs = nixpkgs.legacyPackages."${system}";
          pre-commit-check = pre-commit-hooks.lib."${system}".run {
            src = ./.;
            hooks = {
              black = {
                enable = true;
                raw.fail_fast = true;
              };
              shellcheck = {
                enable = false;
                raw.fail_fast = true;
              };
              alejandra = {
                enable = true;
                excludes = ["^hosts/generic/registry-flake.nix$"];
                raw.fail_fast = true;
              };
              nix-flake-check = {
                enable = false;
                name = "nix: flake check";
                entry = "${pkgs.nixVersions.stable}/bin/nix flake check --no-build";
                pass_filenames = false;
              };
            };
          };
        in {
          default = pkgs.mkShellNoCC {
            inherit (pre-commit-check) shellHook;
            packages = with pkgs; [
              statix
              fnlfmt
              (callPackage ./overlays/optimise/extract-pgo-data {
                nixosPassthru = {
                  hostname = "fake";
                  pgoDir = "fake";
                };
                pkgsToExtractBuildId = null;
              })
              .pythonEnv
            ];
          };
        });
      }
      (import ./overlays inputs)
      {lib = import ./lib;}
    ];
}
