# Core home functionality that will only work on Darwin
{ hostSpec, ... }:
{
  home.sessionPath = [ "/opt/homebrew/bin" ];

  home = {
    username = hostSpec.username;
    homeDirectory = hostSpec.home;
  };
}
