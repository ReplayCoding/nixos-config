{ ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/nvme0n1";
  };
}
