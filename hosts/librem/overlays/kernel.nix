self: super:

{
  linuxPackages_librem = super.linuxKernel.packages.linux_xanmod.extend (final: prev:
    let
      callPackage = super.newScope prev;
    in
    {
      librem-ec-acpi-dkms = callPackage ./librem-ec-acpi-dkms.nix { };
    }
  );
}
