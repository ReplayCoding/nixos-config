self: super:

{
  foot =
    super.foot.override {
      allowPgo = (super.nixosPassthru.pgoMode or "off") == "off";
    };
}
