{
  config,
  pkgs,
  ...
}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    package = pkgs.mesa-optimised.drivers;
    package32 = pkgs.pkgsCross.gnu32.mesa-optimised.drivers;
  };
}
