{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    gfxpayloadBios = "keep";
    device = "/dev/nvme0n1";
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
}
