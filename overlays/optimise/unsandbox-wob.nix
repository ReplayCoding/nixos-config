self: super: {
  wob = super.wob.overrideAttrs (old: {
    mesonFlags = builtins.filter (elem: elem != "-Dseccomp=enabled") (old.mesonFlags or []);
  });
}
