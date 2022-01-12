self: super:

let
  sources = super.callPackages ./_sources/generated.nix { };
in
{
  fuzzel = super.fuzzel.overrideAttrs (old: {
    inherit (sources.fuzzel) src version;
  });
}
