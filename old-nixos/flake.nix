{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      # Bring some useful libraries into the namespace
      inherit (nixpkgs) lib;

      # Load our utilities for generating host and user configurations
      util = import ./lib {
        inherit pkgsBySystem home-manager lib;
      };
      inherit (util) user;
      inherit (util) host;

      # Global configuration for nixpkgs
      nixpkgs-config = {
        config.allowUnfree = true;
        overlays = [];
      };
      makePkg = system: {
        name = system;
        value = import nixpkgs (nixpkgs-config // { inherit system; });
      };
      pkgsBySystem = builtins.listToAttrs (map makePkg ["x86_64-linux" "aarch64-linux"]);

    in {
      homeConfigurations = {
        ggazzi = user.mkHMUser {
          username = "ggazzi";

          userConfig = { ... }: {
            git = {
              enable = true;
              gitg.enable = true;
            };

            applications = {
              enable = true;

              emacs = {
                enable = true;
                native-compilation = true;
              };

              vivaldi = {
                enable = true;
                default = true;
              };

              vscode = {
                enable = true;
                default = true;
              };
            };

            games.minecraft.enable = true;
          };
        };
      };

      nixosConfigurations = {
        carrocinha = host.mkHost {
          name = "carrocinha";
          stateVersion = "21.11";
          system = "x86_64-linux";

          hardware = {
            cpuCores = 4;
            networkingInterfaces = {
              enp2s0 = { useDHCP = true; };
              wlp3s0 = { wifi = true; useDHCP = true; };
            };
            configuration = [ ./hardware/carrocinha.nix ];
          };

          users = [{
            username = "ggazzi";
            uid = 1000;
            home = "/home/ggazzi-nixos";
            groups = [ "wheel" "networkmanager" "video" "docker" "scanner" "lp" ];
          }];

          systemConfig = { pkgs, ... }: {

            graphical = {
              enable = true;
              gnome.enable = true;

              games.steam = true;

              nvidia-optimus = {
                enable = true;
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
              };

            };

            bluetooth.enable = true;
            docker.enable = true;

            printers = {
              enable = true;
              drivers = [pkgs.epson-escpr];
            };
            scanners = {
              enable = true;
              backends = [pkgs.epkowa];
            };
          };
        };
      };
    };
}