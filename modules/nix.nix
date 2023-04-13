{ pkgs, config, lib, ... }:

{
  config = {
    home.packages = with pkgs; [
      # Development tools
      nil
      nixpkgs-fmt
    ];
  };
}
