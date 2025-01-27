{
  description = "Guilherme Azzi's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sub.url = "github:juanibiapina/sub";
    devenv.url = "github:cachix/devenv";
  };

  # TODO: can I move `substituters` and `trusted-public-keys` to `nixConfig` here?

  outputs = inputs@{ nixpkgs, home-manager, sub, devenv, ... }:
    let
      system = "aarch64-darwin";

      overlays = [
        (_self: _super: {
          inherit (devenv.packages.${system}) devenv;

          dev-utils = sub.lib.${system}.mkSubDerivation {
            pname = "dev-utils";
            cmd = "dev";
            version = "0.1.0";
            src = ./dev-utils;
          };
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

    in
    {
      darwinConfigurations."Guilhermes-MacBook-Air" =
        inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./Guilhermes-MacBook-Air/configuration.nix
          ];
        };

      homeConfigurations.gazzi =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules
            {
              ggazzi.neovim.defaultEditor = true;
            }
          ];
        };

      devShell.${system} = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({ pkgs, ... }: {
            languages.nix.enable = true;

            packages = with pkgs; [
              nixpkgs-fmt
              shellcheck
            ];

            pre-commit.hooks = {
              shellcheck.enable = true;
              nixpkgs-fmt.enable = true;
            };
          })
        ];
      };

    };
}
