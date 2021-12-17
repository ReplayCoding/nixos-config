self: super:

let rev = "be7d766e202c2c354db10433be01f926c52f4516";
in
{
  fuzzel = super.fuzzel.overrideAttrs (old: {
    version = rev;
    src = super.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "fuzzel";
      sha256 = "sha256-/KoDyw4hCFz5m6hlGVjpwRLoMphuA9TeWfqPb0JHaRo=";
      inherit rev;
    };
    patches = (old.patches or [ ]) ++ [ ./fuzzel-crop-match-text-to-selection-box-size.patch ];
  });
}
