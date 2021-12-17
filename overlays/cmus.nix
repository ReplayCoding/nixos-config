self: super:
{
  cmus = (super.cmus.overrideAttrs (oldAttrs: {
    configurePhase = oldAttrs.configurePhase + " " + super.lib.concatStringsSep " " [
      "USE_FALLBACK_IP=y"
    ];
  })).override { ffmpeg = super.ffmpeg-full; };
}
