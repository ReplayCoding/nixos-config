self: super: {
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        # Implement startup notifications for workspace matching
        # https://github.com/swaywm/sway/pull/6639
        ./patches/sway-6639.patch
      ];
  });
  cmus = super.cmus.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        # Workaround for #1064
        # https://github.com/cmus/cmus/pull/1172
        ./patches/cmus-1172.patch
      ];
  });
}
