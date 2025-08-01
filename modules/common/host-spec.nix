# Specifications For Differentiating Hosts
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      freeformType = with lib.types; attrsOf str;
      options = {
        # Data variables that don't dictate configuration settings
        username = lib.mkOption {
          type = lib.types.str;
          description = "The username of the host";
        };
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the host";
        };
        email = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "The email of the user";
        };
        work = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of work-related information if isWork is true";
        };
        networking = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of networking information";
        };
        wifi = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate if a host has wifi";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          description = "The domain of the host";
        };
        userFullName = lib.mkOption {
          type = lib.types.str;
          description = "The full name of the user";
        };
        handle = lib.mkOption {
          type = lib.types.str;
          description = "The handle of the user (eg: github user)";
        };
        home = lib.mkOption {
          type = lib.types.str;
          description = "The home directory of the user";
          default =
            let
              user = config.hostSpec.username;
            in
            if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}";
        };

        # Configuration Settings
        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses work resources";
        };
      };
    };
  };

  config = {
    assertions = [
      {
        assertion =
          !config.hostSpec.isWork || (config.hostSpec.isWork && !builtins.isNull config.hostSpec.work);
        message = "isWork is true but no work attribute set is provided";
      }
    ];
  };
}
