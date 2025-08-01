# Core home functionality that will only work on Darwin
{ hostSpec, ... }:
{
  imports = [
    ./darwin/alacritty
  ];

  home.sessionPath = [ "/opt/homebrew/bin" ];

  home = {
    username = hostSpec.username;
    homeDirectory = hostSpec.home;
  };
}
