{ pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    package = pkgs.mesa-optimised.drivers;
    package32 = pkgs.pkgsi686Linux.mesa.drivers;
  };
}
