{ pkgs, lib, ... }:

let rev = "6a4e37a0f66e21be453e392b37d92647a91f2703";
in
{
  nixpkgs.overlays = [
    (self: super: {
      bluez5-experimental = super.bluez5.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [
          "--enable-experimental"
        ];
      });
    })
  ];
}