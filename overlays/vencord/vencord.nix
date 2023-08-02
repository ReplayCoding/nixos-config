{
  mkYarnPackage,
  mkOverridesFromFlakeInput,
}:
mkYarnPackage rec {
  pname = "vencord";
  yarnLock = ./yarn.lock;
  inherit (mkOverridesFromFlakeInput "vencord") version src;

  patchPhase = ''
    runHook prePatch

    patch -p1 < ${./0001-Comment-out-call-to-git-we-patch-the-hash-in-ourselv.patch}
    patch -p1 < ${./0002-Don-t-use-git-remote-to-get-a-url.patch}
    # patch -p1 < ${./0003-Disable-updater.patch}
    sed -i 's/''${gitHash}/${builtins.substring 0 8 version}/g' scripts/build/common.mjs
    sed -i 's/''${NIX_GIT_REMOTE_HERE}/nixos/g' scripts/build/common.mjs

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
