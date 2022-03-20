self: super: {
  libadwaita = super.libadwaita.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./libadwaita-colors.patch];
  });
}
