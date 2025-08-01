{ hostSpec, ... }:
{
  home.stateVersion = "25.05";
  home.homeDirectory = hostSpec.home;
}
