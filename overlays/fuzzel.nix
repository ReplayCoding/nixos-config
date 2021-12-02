{ pkgs, lib, ... }:

let rev = "6a4e37a0f66e21be453e392b37d92647a91f2703";
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
          sha256 = "sha256-o3rDpeH6ZnAcEe9sqA4po7PohdvxwFPvcsWgE9R5csw=";
          inherit rev;
        };
        patches = (old.patches or [ ]) ++
          [
            ./fuzzel-launch-prefix.patch
            ./fuzzel-crop-match-text-to-selection-box-size.patch
          ];
      });
    })
  ];
}
