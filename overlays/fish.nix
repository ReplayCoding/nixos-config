{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      fish = super.fish.overrideAttrs (old: {
        postInstall = ''
          rm $out/share/applications/fish.desktop
        '';
      });
    })
  ];
}
