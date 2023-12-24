{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  boot.loader.grub = {
    enable = true;
    timeoutStyle = "hidden";

    gfxpayloadBios = "keep";
    gfxmodeBios = "1280x720";
    device = "/dev/disk/by-id/nvme-eui.0025385711903f71";
  };
}
