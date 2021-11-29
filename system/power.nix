{ ... }:

{
  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };

  services.logind = rec {
    lidSwitch = "lock";
    lidSwitchDocked = lidSwitch;
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  powerManagement.cpuFreqGovernor = "performance";
}
