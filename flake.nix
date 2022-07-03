rec {
  description = "NixOS configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org" "https://nixpkgs-wayland.cachix.org"];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
    experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:Misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polymc = {
      url = "github:PolyMC/PolyMC";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fuzzel = {
      url = "git+https://codeberg.org/dnkl/fuzzel";
      flake = false;
    };

    dav1d = {
      url = "git+https://code.videolan.org/videolan/dav1d";
      flake = false;
    };
    libplacebo = {
      url = "git+https://code.videolan.org/videolan/libplacebo";
      flake = false;
    };
    mpv = {
      url = "github:mpv-player/mpv";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ragenix,
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
            ragenix.nixosModules.age
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
                arch = "skylake";
                pgoMode = "use";
                mesaConfig = {
                  galliumDrivers = ["iris" "zink" "swrast"];
                  vulkanDrivers = ["intel"];
                };
              };
            }
            {
              system = "x86_64-linux";
              hostname = "thinkpad";
              modules = [./hosts/thinkpad];
              overlayConfig = {
                arch = "btver2";
                mesaConfig = {
                  galliumDrivers = ["radeonsi" "swrast"];
                };
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
                enable = true;
                raw.fail_fast = true;
              };
              alejandra = {
                enable = true;
                excludes = ["^hosts/generic/registry-flake.nix$"];
                raw.fail_fast = true;
              };
              nix-flake-check = {
                enable = true;
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
              ragenix.defaultPackage."${system}"
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
