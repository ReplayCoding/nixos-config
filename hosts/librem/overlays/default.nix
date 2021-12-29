{ ... }:

{
  nixpkgs.overlays = [
    (import ./kernel.nix)
  ];
}
