{
  flib,
  config,
  ...
}: {
  age.secrets = flib.secrets.mkSecrets ./.;
}
