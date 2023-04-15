self: super: {
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./patches/sway-6249.patch
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
