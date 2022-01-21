super:

let
  llvmPackages = super.llvmPackages_13.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  stdenv = (super.overrideCC llvmPackages.stdenv (llvmPackages.stdenv.cc.override {
    inherit (llvmPackages) bintools;
  }));
  makeStatic = s: super.propagateBuildInputs (super.makeStaticLibraries s);
  genericOptions = old: {
    hardeningDisable = [ "all" ];
  };
  mesonOptions = old: (genericOptions old) // {
    mesonBuildType = "release";
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Db_lto=true" "-Db_lto_mode=thin" ];
    ninjaFlags = [ "--verbose" ];
  };
in
{
  inherit
    stdenv
    llvmPackages
    genericOptions
    mesonOptions
    makeStatic;
}
