_: {
  # imports = [./mediapiracy.nix];
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
  };
}
