_: {
  fileSystems = {
    "/".options = ["noatime" "nodiratime" "discard" "compress=zstd"];
    "/home".options = ["noatime" "nodiratime" "discard" "compress=zstd"];
    "/nix".options = ["noatime" "nodiratime" "discard" "compress=zstd"];
  };

  # boot.initrd.luks.devices."enc".allowDiscards = true;
}
