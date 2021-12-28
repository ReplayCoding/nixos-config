{ ... }:

{
  powerManagement.cpuFreqGovernor = "performance";
  services.logind = rec {
    lidSwitch = "lock";
    lidSwitchDocked = lidSwitch;
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };
}
