{ config, lib, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      ruby
      rubyPackages.solargraph
    ];
  };
}
