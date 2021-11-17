{ config, ... }:

let username = config.users.users.user.name;
in
{
  age.secrets = {
    spotifyd-password = {
      file = ./spotifyd-password.age;
      owner = username;
    };
  };
}
