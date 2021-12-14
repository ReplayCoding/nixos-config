_:

{
  boot.zfs = {
    enableUnstable = true;
    forceImportRoot = false;
  };
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "7c5b9af1";
}
