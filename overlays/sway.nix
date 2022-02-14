self: super:

{
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++
      [
        # Implement startup notifications for workspace matching
        # https://github.com/swaywm/sway/pull/6639
        ./sway-6639.patch

        # Tray D-Bus Menu
        # https://github.com/swaywm/sway/pull/6249
        ./sway-6249.patch
      ];
  });
}
