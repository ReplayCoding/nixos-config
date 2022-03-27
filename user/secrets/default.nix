{config, ...}: let
  username = config.users.users.user.name;
in {
  age.secrets = {
    user-ssh-key = {
      file = ./user-ssh-key.age;
      owner = username;
    };
  };
}
