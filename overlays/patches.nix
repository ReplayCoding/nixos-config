self: super: {
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./patches/sway-6249.patch
      ];
  });
}
