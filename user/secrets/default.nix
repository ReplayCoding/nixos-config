{config, ...}: let
  secrets = import ./secrets.nix;
in {
  age.secrets = builtins.foldl' (a: b: a // b) {} (
    builtins.map
    (fname: {
      "${builtins.replaceStrings [".age"] [""] fname}" = {
        file = ./${fname};
        owner = config.users.users.user.name;
      };
    })
    (builtins.attrNames secrets)
  );
}
