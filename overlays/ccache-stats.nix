self: super: let
  inherit (import ./optimise-utils.nix super) stdenv;
in {
  ccache-stats = super.writeShellScriptBin "ccache-stats" ''
    export CCACHE_CONFIGPATH=${stdenv.cc.ccacheConfig}
    ${super.ccache}/bin/ccache --show-stats --verbose
  '';
}
