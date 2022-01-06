self: super:

{
  bluez5-experimental = super.bluez5.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [
      "--enable-experimental"
    ];
  });
}
