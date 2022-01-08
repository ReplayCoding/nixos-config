_:

{
  services = {
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    power-profiles-daemon.enable = true;
  };
}
