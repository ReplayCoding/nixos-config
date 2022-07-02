self: super: {
  fuzzel = super.fuzzel.overrideAttrs (old: {
    src = super.nixosFlakeInputs.fuzzel;
    version = super.nixosFlakeInputs.fuzzel.rev;
  });
}
