{ config, pkgs, lib, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        DiscoverableTimeout = 0;
        FastConnectable = "true";
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
      };
    };
  };
}
