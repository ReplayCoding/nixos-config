{
  config,
  pkgs,
  ...
}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    package = pkgs.mesa-optimised.drivers;
    package32 = let
      pkgs32 = import pkgs.path {
        inherit (config.nixpkgs) localSystem config overlays;
        crossSystem = pkgs.lib.systems.examples.gnu32;
      };
    in
      pkgs32.mesa-optimised.drivers;
  };
}
