{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.qt5.qtwayland];
}
