{
  description = "Guilherme Azzi's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sub.url = "github:juanibiapina/sub";
    devenv.url = "github:cachix/devenv";
    nixvim = {
      url = "path:./nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: can I move `substituters` and `trusted-public-keys` to `nixConfig` here?

  outputs = inputs@{ nixpkgs, home-manager, sub, devenv, ... }:
    let
      system = "aarch64-darwin";

      overlays = [
        (_self: _super: {
          inherit (devenv.packages.${system}) devenv;

          nixvim = inputs.nixvim.packages.${system}.default;

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

      devShells.${system}.default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({ pkgs, ... }: {
            languages.nix.enable = true;

            packages = with pkgs; [
              nixpkgs-fmt
              shellcheck
            ];

            pre-commit.hooks = {
              shellcheck = {
                enable = true;
                excludes = [ "\\.zsh" ];
              };

              nixpkgs-fmt.enable = true;
            };
          })
        ];
      };

    };
}
