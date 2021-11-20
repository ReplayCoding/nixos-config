{ pkgs, config, lib, ... }:

{
  containers.mediapiracy = {
    config = import ./mediapiracy.nix;
    bindMounts = {
      "/var/lib/sonarr" = { isReadOnly = false; };
      "/var/lib/transmission" = { isReadOnly = false; };

      "/home/sonarr" = { isReadOnly = false; };
    };
    ephemeral = true;
  };

  containers.jellyfin = {
    config = import ./jellyfin.nix;
    bindMounts = {
      "/var/lib/jellyfin" = { isReadOnly = false; };

      "/home/jelly" = { isReadOnly = false; };
      "/home/sonarr" = { isReadOnly = false; };
    };
    ephemeral = true;
  };
}
