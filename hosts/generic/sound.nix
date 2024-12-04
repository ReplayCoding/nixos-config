{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.enable = true;
  };

  # Useful to change audio output
  environment.systemPackages = with pkgs; [pulseaudio];
}
