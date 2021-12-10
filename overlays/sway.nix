{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./sway-dbus-menus.patch ];
      });
    })
  ];
}
