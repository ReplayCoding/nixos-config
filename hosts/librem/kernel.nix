{
  config,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.myLinuxPackages-librem;
  boot.extraModulePackages = with config.boot.kernelPackages; [librem-ec-acpi-dkms];
  boot.initrd.kernelModules = ["i915"];
  zramSwap = {
    enable = true;
    priority = 2;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
      priority = 1;
    }
  ];

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
}
