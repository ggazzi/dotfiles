{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOs/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }@inputs:
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
            groups = [ "wheel" "networkmanager" "video" "docker" ];

          }];

          systemConfig = { pkgs, ... }: {

            desktop = {
              enable = true;
              games.steam = true;

              nvidia-optimus = {
                enable = true;
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
              };

            };

            docker.enable = true;

            printers = {
              enable = true;
              drivers = [pkgs.epson-escpr];
            };
          };
        };

        rascal = host.mkHost {
          name = "rascal";
          system = "aarch64-linux";
          stateVersion = "22.05";

          hardware = {
            cpuCores = 4;
            networkingInterfaces = {
              wlan0 = { wifi = true; useDHCP = true; };
              eth0 = {
                useDHCP = false;
                ipv4.addresses = [{
                  address = "192.168.1.2";
                  prefixLength = 24;
                }];
              };
            };
            configuration = [ ./hardware/rascal.nix nixos-hardware.nixosModules.raspberry-pi-4 ];
          };

          users = [{
            username = "ggazzi";
            uid = 1000;
            home = "/home/ggazzi";
            groups = [ "wheel" "docker" ];
          }];

          systemConfig = { ... }: {
            boot.efi.enable = false;
            networkmanager.enable = false;
            desktop.enable = false;
            docker.enable = true;
            sshd.enable = true;
          };

        };
      };
    };
}
