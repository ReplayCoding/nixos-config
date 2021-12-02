_:

{
  imports = [
    ./sound.nix
    ./console.nix
    ./zfs.nix
    ./network.nix
    ./ssh.nix
    ./nix.nix
    ./power.nix
  ];

  services.logind.killUserProcesses = true;
}
