{ pkgs, ... }:

let
  wrapper = pkgs.symlinkJoin {
    name = "chromium-wrapper";
    paths = [ pkgs.ungoogled-chromium ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/chromium \
        --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
      wrapProgram $out/bin/chromium-browser \
        --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };
in
{
  programs.chromium = {
    enable = true;
    package = wrapper;
  };
}
