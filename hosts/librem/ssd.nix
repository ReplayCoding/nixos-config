_: {
  fileSystems = {
    "/".options = ["noatime" "nodiratime" "discard" "compress=zstd"];
    "/home".options = ["noatime" "nodiratime" "discard" "compress=zstd"];
    "/nix".options = ["noatime" "nodiratime" "discard" "compress=zstd"];
  };
}
