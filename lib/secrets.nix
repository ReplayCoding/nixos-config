{
  mkSecrets = dir: let
    secrets = import "${dir}/secrets.nix";
  in
    builtins.foldl' (a: b: a // b) {} (
      builtins.map
      (fname: {
        "${builtins.replaceStrings [".age"] [""] fname}" = {
          file = "${dir}/${fname}";
          inherit (secrets."${fname}") owner;
        };
      })
      (builtins.attrNames secrets)
    );
}
