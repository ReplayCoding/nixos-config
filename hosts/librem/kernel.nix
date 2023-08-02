{
  config,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.myLinuxPackages-librem;
  boot.extraModulePackages = with config.boot.kernelPackages; [librem-ec-acpi-dkms];
  boot.kernelParams = ["usbcore.autosuspend=-1"];
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

  services.beesd.filesystems.root = {
    verbosity = "crit";
    spec = "UUID=87314a68-6010-472a-993f-4e4f0c15cfe0";
    extraOptions = ["--thread-count" "4"];
  };
}
