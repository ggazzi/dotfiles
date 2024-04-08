{ pkgs, config, lib, ... }:

{
  config = {
    home.packages = with pkgs; [
      awscli2
    ];
  };
}
