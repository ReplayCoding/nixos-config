{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    powerOnBoot = true;
    settings = {
      General = {
        DiscoverableTimeout = 0;
        FastConnectable = "true";
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        Experimental = true;
      };
    };
  };
}
