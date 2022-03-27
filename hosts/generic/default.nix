_: {
  imports = [
    ./sound.nix
    ./console.nix
    ./zfs.nix
    ./network.nix
    ./ssh.nix
    ./nix.nix
    ./power.nix
    ./greetd.nix
    ./printing.nix
    ./journal.nix
    ./bluetooth.nix
    ./opengl.nix
    ./firmware.nix
    ./pgo.nix
  ];

  boot.cleanTmpDir = true;
}
