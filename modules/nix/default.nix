{ pkgs, config, lib, ... }:

{
  config = {
    home.packages = with pkgs; [
      cachix
      devenv

      # Development tools
      nil
      nixpkgs-fmt
    ];

    programs.helix.languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixpkgs-fmt";
          };
        }
      ];
    };

    xdg.configFile = {
      "nix/nix.conf".source = ./nix.conf;
    };
  };
}
