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
in
{ inherit stdenv makeStatic; }
