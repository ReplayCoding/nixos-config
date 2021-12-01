{ config, ... }:

let username = config.users.users.user.name;
in
{
  age.secrets = {
    work-email-password = { file = ./work-email-password.age; owner = username; };
  };
}
