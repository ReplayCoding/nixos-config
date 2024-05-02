{pkgs, ...}: {
  boot.zfs = {
    forceImportRoot = false;
  };
  # boot.supportedFilesystems = ["zfs"];
}
