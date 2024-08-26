{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./sound.nix
    ./zfs.nix
    ./network.nix
    ./nix.nix
    ./power.nix
    ./printing.nix
    ./journal.nix
    ./bluetooth.nix
    ./opengl.nix
    ./fonts.nix
    ./documentation.nix
    ./firmware.nix
    ./pgo.nix
    ./boot.nix
    ./containers
  ];

  # misc. options
  i18n.defaultLocale = "en_CA.UTF-8";

  programs.adb.enable = true;

  virtualisation.kvmgt = {
    enable = true;
    vgpus = {
      "i915-GVTg_V5_4" = {
        uuid = ["ef328ade-07f0-11ee-883d-a7d2c7c761e7"];
      };
    };
  };

  environment.systemPackages = [pkgs.virtiofsd];
  virtualisation.libvirtd = {
    enable = true;

    onShutdown = "shutdown";
    onBoot = "ignore";

    qemu = {
      package = pkgs.qemu_kvm;
      vhostUserPackages = [pkgs.virtiofsd];
      ovmf.enable = true;
      ovmf.packages = [pkgs.OVMFFull.fd];
      swtpm.enable = true;
      runAsRoot = false;
    };
  };

  # services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.mysql.settings.mysqld.bind-address = "127.0.0.1";
  # services.joycond.enable = true;

  programs.partition-manager.enable = true;

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    settings = {
      Autologin = {
        User = "user";
        Session = "plasma";
      };
    };
  };

  boot.supportedFilesystems = ["ntfs"];

  # not really useful on nixos, unfortunately
  # security.apparmor.enable = true;
  # services.dbus.apparmor = "enabled";
  services.dbus.implementation = "broker";
  services.logind.killUserProcesses = true;
  virtualisation.spiceUSBRedirection.enable = true; # secure my ass

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';
}
