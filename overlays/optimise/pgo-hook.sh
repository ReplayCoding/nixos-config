#!/usr/bin/env bash
fixupOutputHooks+=(_writePgoName)

_writePgoName() {
  # shellcheck disable=SC2154
  mkdir -p "$prefix/nix-support"
  echo "writing PGO profile name to $prefix"
  echo "$PGO_SUPPORT_DATA" > "$prefix/nix-support/pgo-support"
}
