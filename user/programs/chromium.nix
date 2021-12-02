{ pkgs, ... }:

let
  wrapper = pkgs.symlinkJoin {
    name = "chromium-wrapper";
    paths = [ pkgs.ungoogled-chromium ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild =
      # --force-dark-mode until chromium respects my theme :|
      let flags = "--enable-features=UseOzonePlatform,VaapiVideoDecoder --ozone-platform=wayland --force-dark-mode";
      in
      ''
        wrapProgram $out/bin/chromium \
          --add-flags "${flags}"
        wrapProgram $out/bin/chromium-browser \
          --add-flags "${flags}"
      '';
  };
in
{
  programs.chromium = {
    enable = true;
    package = wrapper;
  };
}
