# Core functionality for every nix-darwin host.
{
  config,
  ...
}:

{
  system.primaryUser = config.hostSpec.username;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Nix managed by Determinate instead
  nix.enable = false;
}
