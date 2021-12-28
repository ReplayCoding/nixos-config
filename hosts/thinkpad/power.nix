{ ... }:

{
  powerManagement.cpuFreqGovernor = "performance";
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
}
