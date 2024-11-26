{
  secrets,
  config,
  pkgs,
  ...
}: {
  programs.ncspot = {
    enable = true;
    settings = {
      default_keybindings = true;
      bitrate = 160;
      audio_cache_size = 100;
      flip_status_indicators = true;
      use_nerdfont = true;
      hide_display_names = true;
      volnorm = true;
      gapless = true;
      repeat = "track";
      backend = "pulseaudio";
    };
  };

  home.packages = with pkgs; [spotify];
}
