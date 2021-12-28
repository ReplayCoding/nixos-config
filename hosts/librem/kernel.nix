{ ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    gfxpayloadBios = "keep";
    device = "/dev/nvme0n1";
  };
}
