{
  config,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    # package = pkgs.mesa-optimised.drivers;
    # package32 = pkgs.mesa-optimised-32.drivers;
  };
}
