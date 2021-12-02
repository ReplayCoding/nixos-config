{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      fish = super.symlinkJoin {
        inherit (super.fish) passthru;
        name = "fish-wrapped";
        paths = [ super.fish ];
        postBuild = ''
          rm $out/share/applications/fish.desktop
        '';
      };
    })
  ];
}
