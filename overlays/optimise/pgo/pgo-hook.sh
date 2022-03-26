fixupOutputHooks+=(_writePgoName)

_writePgoName() {
  mkdir -p $prefix/nix-support
  echo "writing PGO profile name to $prefix"
  echo $PGO_PROFILE_NAME > $prefix/nix-support/pgo-support-name
}
