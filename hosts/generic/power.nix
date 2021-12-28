_:

{
  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };

  services.logind = rec {
    lidSwitch = "lock";
    lidSwitchDocked = lidSwitch;
  };
}
