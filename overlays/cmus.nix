{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      cmus = (super.cmus.overrideAttrs (oldAttrs: {
        configurePhase = oldAttrs.configurePhase + " " + lib.concatStringsSep " " [
          "USE_FALLBACK_IP=y"
        ];
      })).override { ffmpeg = super.ffmpeg-full; };
    })
  ];
}
