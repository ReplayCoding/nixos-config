self: super: {
  fuzzel = super.fuzzel.overrideAttrs (old: {
    inherit (super.mkOverridesFromFlakeInput "fuzzel") src version;
  });
}
