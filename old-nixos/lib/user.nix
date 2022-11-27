{ pkgsBySystem, home-manager, lib, ... }:
with builtins;
let
  resolveHome = {username, home}: if home == null then "/home/${username}" else home;
in {
  # Function used to create a user configuration with Home Manager
  mkHMUser = {
    # The same username as used in the system configuration
    username,

    # Options that will be read by the user configuration module
    userConfig
  }:
    let
      tryReadSettings = tryEval (fromJSON (readFile /etc/hmsystemdata.json));
      machineData = if tryReadSettings.success then tryReadSettings.value else {};

      homeDirectory = machineData.users."${username}".home;
      stateVersion = machineData.stateVersion;
      system = machineData.system;
      pkgs = pkgsBySystem."${system}";
    in home-manager.lib.homeManagerConfiguration {
      inherit system pkgs username homeDirectory stateVersion;

      configuration =
        let
          # Pack the system config data into a module, so it can be accessed by our custom modules.
          machineModule = { pkgs, config, lib, ... }: {
            options.machineData = lib.mkOption {
              default = {};
              description = "Settings passed from nixos system configuration. Will be empty if not present.";
            };

            config.machineData = machineData;
          };
        in {
          # Save the custom user config to ggazzi to avoid any conflicts with other modules
          ggazzi = userConfig { inherit pkgs; };

          nixpkgs.overlays = pkgs.overlays;
          nixpkgs.config.allowUnfree = true;

          systemd.user.startServices = true;
          home = { inherit username homeDirectory stateVersion; };

          imports = [ ../modules/users machineModule ];
        };
    };

  # Function used to create a user in a system configuration
  mkSystemUser = pkgs : {
    # The regular username (`users.users."${username}".name`)
    username,

    # Same as `users.users."${username}".uid`
    uid,

    # Path to the home directory (`users.users."${username}".home`).
    # Default: "/home/${username}"
    home ? null,

    # Names of groups to which the user should be added
    # (`users.users."${username}".extraGroups`)
    groups,

    # Path or package of the user shell (`users.users."${username}".shell`)
    shell ? pkgs.bashInteractive,

    ...
  }:
  {
    users.users."${username}" = {
      name = username;
      isNormalUser = true;
      isSystemUser = false;
      extraGroups = groups;
      uid = uid;
      initialPassword = "password";
      home = resolveHome { inherit username home; };
      shell = shell;
    };
  };

  # Extracts system information about the given users that is used by the user configuration.
  # Receives a list of sets that are valid as arguments for `mkSystemUser`.
  mkSystemUserData =
    let
      mkUserData = {username, home, ...}: {
        name = username;
        value = { home = resolveHome { inherit username home; }; };
      };
    in users: listToAttrs (map mkUserData users);
}
