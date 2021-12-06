{ secrets, config, pkgs, ... }:

{
  programs.ncspot = {
    enable = true;
    settings = {
      default_keybindings = true;
      bitrate = 96;
      flip_status_indicators = true;
      use_nerdfont = true;
      gapless = true;
      repeat = "track";
      backend = "pulseaudio";
    };
  };
}
