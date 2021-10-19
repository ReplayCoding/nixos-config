{ symlinkJoin, makeWrapper, lib }:

{ browser }:

symlinkJoin {
  name = "my-chromium-wrapped";
  paths = [
    (browser.override { enableWideVine = false; })
  ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/chromium \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    wrapProgram $out/bin/chromium-browser \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
  '';
}
