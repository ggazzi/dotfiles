{ pkgsBySystem, home-manager, lib, user, ...}:
with builtins;
{
  # Function used to build the configuration for a host
  mkHost = {
    # Will be used as hostname
    name,

    # Nix platform type for this host, will be used as `nixpkgs.system`
    system,

    # A set containing the following hardware/kernel options.
    #
    #  - `cpuCores`: self-explanatory.
    #
    #  - `networkingInterfaces`: set of networking interfaces.    #
    #    Can be obtained from the auto-generated configuration
    #    by finding lines with `networking.interfaces.<name>.useDHCP = true;`.
    #    Each of them is a set containing the options that would go in
    #    `networking.interfaces.<name>`, optionally with an additional
    #    boolean entry `wifi` to idenfity wireless interfaces.
    #
    #  - `configuration`: path to an auto-generated hardware configuration module.
    #
    #  - TODO document gpuTempSensor (optional)
    #
    #  - TODO document cpuTempSensor (optional)
    #
    hardware,

    # Options that will be read by the system configuration module.
    # This is a function taking the following set of parameters:
    #
    #  - `pkgs`: the instantiated and configurated nixpkgs.
    #
    systemConfig,

    # NixOS release from which the default settings for stateful data,
    # like file locations and database versions on your system were taken.
    #
    # It‘s perfectly fine and recommended to leave this value at
    # the release version of the first install of this system.
    # Before changing this value read the documentation for
    # the system.stateVersion option.
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion,

    # List of users to be created, must be valid arguments for the
    # function `mkSystemUser` from `./user.nix`.
    users,

    # Additional modules to be imported by this configuration
    modules ? [],
  }:
  let
    default_hardware = {
      networkingInterfaces = []; wifi = [];
      gpuTempSensor = null; cpuTempSensor = null;
    };

    hwconfig = default_hardware // hardware;
    pkgs = pkgsBySystem."${system}";
    config = systemConfig { inherit pkgs; };
  in lib.nixosSystem {
    inherit system;

    modules = [
      {
        imports = [ ../modules/system ] ++ hardware.configuration ++ (map (user.mkSystemUser pkgs) users);

        # Save the custom system config to ggazzi to avoid any conflicts with other modules
        ggazzi = config;

        # Write configuration data to a file so it can be used by home-manager
        environment.etc = {
          "hmsystemdata.json".text = toJSON {
            inherit name system stateVersion;
            systemConfig = config;
            hardware = with hwconfig; { inherit cpuCores gpuTempSensor cpuTempSensor; };
            users = user.mkSystemUserData users;
          };
        };

        # Network configuration
        networking.hostName = "${name}";
        networking.interfaces = mapAttrs (name: value: removeAttrs value ["wifi"]) hwconfig.networkingInterfaces;
        networking.wireless.interfaces = filter
          (name: hwconfig.networkingInterfaces."${name}" ? wifi && hwconfig.networkingInterfaces."${name}".wifi)
          (attrNames hwconfig.networkingInterfaces);

        # The global useDHCP flag is deprecated, therefore explicitly set to false here.
        networking.useDHCP = false;

        # Nix configuration
        nixpkgs.pkgs = pkgs;
        nix.maxJobs = lib.mkDefault hwconfig.cpuCores;
        system.stateVersion = stateVersion;
      }
    ];

  };
}
