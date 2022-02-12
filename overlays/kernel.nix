final: prev: {
  myLinuxPackages =
    prev.linuxKernel.packages.linux_xanmod.extend (
      self: super:
        let
          callPackage = final.newScope super;
        in
        { librem-ec-acpi-dkms = callPackage ./librem-ec-acpi-dkms.nix { }; }
    );
}
