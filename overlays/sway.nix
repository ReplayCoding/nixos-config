self: super: {
  wlroots = super.wlroots.overrideAttrs (old: {
    # https://gitlab.freedesktop.org/wlroots/wlroots/-/merge_requests/3500
    patches = (old.patches or []) ++ [./patches/wlroots-3500.patch];
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
