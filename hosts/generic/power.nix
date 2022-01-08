{ pkgs, ... }:

{
  services = {
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    power-profiles-daemon.enable = true;
  };
  environment.systemPackages = with pkgs; [ lm_sensors ];
}
