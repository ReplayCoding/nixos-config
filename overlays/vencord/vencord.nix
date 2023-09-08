{
  mkYarnPackage,
  mkOverridesFromFlakeInput,
}:
mkYarnPackage rec {
  pname = "vencord";
  yarnLock = ./yarn.lock;
  inherit (mkOverridesFromFlakeInput "vencord") version src;

  VENCORD_REMOTE = "nixos";

  patchPhase = ''
    runHook prePatch

    patch -p1 < ${./0001-Comment-out-call-to-git-we-patch-the-hash-manually.patch}
    sed -i 's/''${gitHash}/${builtins.substring 0 8 version}/g' scripts/build/common.mjs

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r deps/vencord/dist/ $out

    runHook postInstall
  '';

  distPhase = "#";
}
