self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions_pgo mesonOptions_pgo fakeExtra makeStatic createWithBuildIdList getDrvName;

  mkOptimisedPipewire = pgoMode: let
    fdk_aac = (super.fdk_aac.override {stdenv = makeStatic stdenv;}).overrideAttrs (autotoolsOptions_pgo (getDrvName self.pipewire-optimised) pgoMode (old: {
      configureFlags = (old.configureFlags or []) ++ ["--with-pic"];
    }));
    pipewire-optimised =
      (super.pipewire.override {inherit stdenv fdk_aac;}).overrideAttrs (mesonOptions_pgo (getDrvName self.pipewire-optimised) pgoMode fakeExtra);
  in {inherit pipewire-optimised;};
in
  createWithBuildIdList super mkOptimisedPipewire
