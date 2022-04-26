self: super: {
  foot = super.foot.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [./patches/foot-1044.patch];
  });
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        # Implement startup notifications for workspace matching
        # https://github.com/swaywm/sway/pull/6639
        ./patches/sway-6639.patch

        # Tray D-Bus Menu
        # https://github.com/swaywm/sway/pull/6249
        ./patches/sway-6249.patch
      ];
  });
}
