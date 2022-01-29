self: super:

let
  inherit (import ./optimise-utils.nix super) _ccacheConfig;
in
{
  ccache-stats = super.writeShellScriptBin "ccache-stats" ''
    export CCACHE_CONFIGPATH=${_ccacheConfig}
    ${super.ccache}/bin/ccache --show-stats --verbose
  '';
}
