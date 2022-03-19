_: {
  powerManagement.cpuFreqGovernor = "schedutil";
  services.logind = rec {
    lidSwitch = "lock";
    lidSwitchDocked = lidSwitch;
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };
}
