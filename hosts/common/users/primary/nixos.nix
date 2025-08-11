# User config applicable only to nixos
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostSpec = config.hostSpec;
  ifTheyExist = builtins.filter (group: builtins.hasAttr group config.users.groups);
in
{
  users.users.${hostSpec.username} = {
    home = "/home/${hostSpec.username}";
    isNormalUser = true;

    extraGroups = lib.flatten [
      "wheel"
      (ifTheyExist [
        "audio"
        "video"
        "docker"
        "git"
        "networkmanager"
        "bluetooth"
        "scanner" # for print/scan
        "lp" # for print/scan
      ])
    ];
  };

  # No matter what environment we are in, we want these tools for root, and the user(s)
  programs.git.enable = true;

  users.users.root = {
    shell = pkgs.zsh;
  };
}
