final: prev: let
in {
  myLinuxPackages-librem = final.linuxKernel.packages.linux_xanmod_latest.extend (
    self: super: let
      callPackage = final.newScope super;
    in {librem-ec-acpi-dkms = callPackage ./librem-ec-acpi-dkms.nix {};}
  );
}
