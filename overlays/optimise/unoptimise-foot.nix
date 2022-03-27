self: super: {
  foot = super.foot.override {
    allowPgo = false;
  };
}
