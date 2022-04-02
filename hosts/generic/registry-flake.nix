{
  description = "NixOS system packages";
  inputs = {
    nixos.url = "path:@NIXOS@";
    nixpkgs.url = "path:@NIXPKGS@";
  };
  outputs = {self, nixos, nixpkgs}:
    let
      systems = nixpkgs.lib.systems.supported.hydra;
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      packages = forAllSystems (system: import nixpkgs {
        localSystem.system = system;
        overlays = [(nixos.lib.mkOverlay nixos.overlayConfig.@HOSTNAME@)];
      });
    };
}
