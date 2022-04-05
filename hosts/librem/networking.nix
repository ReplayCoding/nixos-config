{
  config,
  pkgs,
  lib,
  ...
}: {
  networking = {
    hostName = "librem";
    hostId = "4dfa248b";
  };
  environment.systemPackages = [pkgs.iw];
}
