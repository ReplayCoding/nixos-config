self: super: {
  libadwaita = super.libadwaita.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./patches/libadwaita-colors.patch];
  });
}
