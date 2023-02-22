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
        mkdir -p $out/opt/Discord/resources/app

        echo 'require("${vencord}/patcher.js")' > $out/opt/Discord/resources/app/index.js
        echo '{"name": "discord", "main": "index.js"}' > $out/opt/Discord/resources/app/package.json
      '';
  })
