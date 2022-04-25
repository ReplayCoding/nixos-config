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
    ./fonts.nix
    ./documentation.nix
    ./firmware.nix
    ./pgo.nix
    ./containers
  ];

  # misc. options
  i18n.defaultLocale = "en_US.UTF-8";
  boot.cleanTmpDir = true;
  boot.initrd.systemd.enable = true;
}
