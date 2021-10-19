{ config, pkgs, lib, ... }:

{
  users.groups = {
    mediapiracy = { };
  };

  services.jellyfin = {
    enable = true;
    group = "mediapiracy";
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    group = "mediapiracy";
  };
  services.radarr = {
    enable = true;
    group = "mediapiracy";
    openFirewall = true;
  };
  services.transmission = {
    enable = true;
    group = "mediapiracy";
    openFirewall = true;
  };
}
