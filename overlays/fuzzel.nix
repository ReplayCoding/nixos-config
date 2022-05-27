self: super: let
  sources = (import ../lib).sources super;
in {
  fuzzel = super.fuzzel.overrideAttrs (old: {
    inherit (sources.fuzzel) src version;
  });
}
