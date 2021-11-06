{ pkgs, config, lib, ... }:

{
  containers.mediapiracy = {
    config = import ./mediapiracy.nix;
    bindMounts = {
      "/var/lib/jellyfin" = { isReadOnly = false; };
      "/var/lib/sonarr" = { isReadOnly = false; };
      "/var/lib/transmission" = { isReadOnly = false; };

      "/home/jelly" = { isReadOnly = false; };
      "/home/sonarr" = { isReadOnly = false; };
    };
    ephemeral = true;
  };
}
