{ pkgs, lib, ... }:

let rev = "817daecee60041ab18c36e8b068d915d73e3147e";
in
{
  nixpkgs.overlays = [
    (self: super: {
      fuzzel = super.fuzzel.overrideAttrs (old: {
        version = rev;
        src = super.fetchFromGitea {
          domain = "codeberg.org";
          owner = "dnkl";
          repo = "fuzzel";
          sha256 = "sha256-BCyqwS8Ev7Gy78dp4FZZnDAW7feJHz/hchYMduhTCVw=";
          inherit rev;
        };
        patches = (old.patches or [ ]) ++ [ ./fuzzel-launch-prefix.patch ];
      });
    })
  ];
}
