{
  description = "Guilherme Azzi's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dev-cli-utils = {
      url = "github:ggazzi/dev-cli-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, dev-cli-utils, ... }@inputs:
    {

      homeConfigurations.gazzi =
        let
          system = "aarch64-darwin";
          overlays = [
            (self: super: {
              dev-cli-utils = dev-cli-utils.packages.${system}.default;
            })
          ];
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system overlays;
            config = { allowUnfree = true; };
          };
          modules = [ ./modules ];
        };
    };
}
