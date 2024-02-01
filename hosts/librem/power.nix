{pkgs, ...}: {
  services.thermald.enable = true;
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
  '';
}
