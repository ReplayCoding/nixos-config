{
  config,
  pkgs,
  ...
}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    package = pkgs.mesa-optimised.drivers;
    package32 = pkgs.mesa-optimised-32.drivers;
  };
}
