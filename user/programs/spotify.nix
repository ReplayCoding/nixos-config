{ secrets, config, pkgs, ... }:

{
  home.packages = [ pkgs.spotify-tui ];
  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; };
    settings.global = {
      username = "6dx7kymdibwzhi3cj14is223f";
      password_cmd = "${pkgs.busybox}/bin/cat ${secrets.spotifyd-password.path}";

      use_mpris = true;
      bitrate = 320;
      device_type = "computer";
      cache_path = "${config.xdg.cacheHome}/spotifyd";
    };
  };
}
