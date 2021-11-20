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
}
