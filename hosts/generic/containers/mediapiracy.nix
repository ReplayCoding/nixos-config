_: let
  prefix = "/var/lib/mediapiracy";
in {
  containers.mediapiracy = {
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      users.groups = {
        mediapiracy = {};
      };

      services.sonarr = {
        enable = true;
        group = "mediapiracy";
      };
      services.transmission = {
        enable = true;
        group = "mediapiracy";
        settings = {
          idle-seeding-limit = 1;
          idle-seeding-limit-enabled = true;
          ratio-limit = 0;
          ratio-limit-enabled = true;
        };
        openPeerPorts = true;
      };
      system.stateVersion = "22.05";
    };
    bindMounts = {
      "/var/lib/sonarr" = {
        hostPath = "${prefix}/sonarr";
        isReadOnly = false;
      };
      "/var/lib/transmission" = {
        hostPath = "${prefix}/transmission";
        isReadOnly = false;
      };

      "/data" = {
        hostPath = "${prefix}/data";
        isReadOnly = false;
      };
    };
    ephemeral = true;
  };
}
