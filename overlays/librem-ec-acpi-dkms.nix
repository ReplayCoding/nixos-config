{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
}: let
  rev = "v0.9.2";
in
  stdenv.mkDerivation rec {
    pname = "librem-ec-acpi-dkms";
    version = "${rev}-${kernel.version}";

    src = fetchFromGitLab {
      domain = "source.puri.sm";
      owner = "nicole.faerber";
      repo = "librem-ec-acpi-dkms";
      sha256 = "sha256-gPb1/4UPbwjJiqtP27KKjiIKxIYEl2nlQACUAlxVEFU=";
      inherit rev;
    };

    hardeningDisable = ["pic"];

    KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
    INSTALL_MOD_PATH = placeholder "out";

    nativeBuildInputs = kernel.moduleBuildDependencies;

    inherit (kernel) makeFlags;
    buildFlags = ["all"];

    installFlags = ["DEPMOD=true"];
    enableParallelBuilding = true;

    patches = [
      ./patches/librem-ec-acpi-dkms.patch
    ];

    meta = with lib; {
      homepage = "https://source.puri.sm/nicole.faerber/librem-ec-acpi-dkms";
      maintainers = [maintainers.avieth];
      license = lib.licenses.gpl2;
      description = "Kernel module for the Purism Librem EC ACPI DKMS";
      platforms = platforms.linux;
    };
  }
