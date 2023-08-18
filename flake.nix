{
  description = "Guilherme Azzi's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sub.url = "github:juanibiapina/sub";
  };

  outputs = { nixpkgs, home-manager, sub, ... }:
    {

      homeConfigurations.gazzi =
        let
          system = "aarch64-darwin";
          overlays = [
            (self: super: {
              dev-utils = sub.lib.${system}.mkSubDerivation {
                pname = "dev-utils";
                cmd = "dev";
                version = "0.1.0";
                src = ./dev-utils;
              };
            })
          ];
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system overlays;
            config = {
              allowUnfree = true;
              ggazzi = {
                helix.defaultEditor = true;
              };
            };
          };
          modules = [ ./modules ];
        };
    };
}
