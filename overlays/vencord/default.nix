{
  lib,
  stdenvNoCC,
  discord,
  callPackage,
}: let
  vencord = callPackage ./vencord.nix {};
in
  discord.overrideAttrs (old: {
    name = "discord-vencord";

    postInstall =
      old.postInstall
      + ''
        mv $out/opt/Discord/resources/app.asar $out/opt/Discord/resources/_app.asar
        mkdir -p $out/opt/Discord/resources/app.asar

        echo 'require("${vencord}/patcher.js")' > $out/opt/Discord/resources/app.asar/index.js
        echo '{"name": "discord", "main": "index.js"}' > $out/opt/Discord/resources/app.asar/package.json
      '';
  })
