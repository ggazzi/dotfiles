{
  description = "Gui's neovim config (nixvim), standalone until it's ported to plain Lua";

  outputs =
    {
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (
        self: super: {
          custom = import ./lib {
            inherit (nixpkgs) lib;
            inherit inputs;
          };
        }
      );

      homeModule =
        { pkgs, ... }:
        {
          imports = [ ./home/gazzi/common/core/nixvim ];

          home.username = "gazzi";
          home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/gazzi" else "/home/gazzi";
          home.stateVersion = "23.05";
        };
    in
    {
      homeConfigurations = builtins.listToAttrs (
        map (system: {
          name = system;
          value = home-manager.lib.homeManagerConfiguration {
            inherit lib;
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = { inherit inputs; };
            modules = [ homeModule ];
          };
        }) systems
      );
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
