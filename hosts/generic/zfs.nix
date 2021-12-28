_:

{
  boot.zfs = {
    enableUnstable = true;
    forceImportRoot = false;
  };
  boot.supportedFilesystems = [ "zfs" ];
}
