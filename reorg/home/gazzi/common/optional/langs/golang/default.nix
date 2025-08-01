{ ... }:

{
  config = {
    programs.git = {
      extraConfig = {
        url."ssh://git@github.com/lessonnine".insteadOf = "https://github.com/lessonnine";
      };
    };

    home.sessionVariables = {
      GOPRIVATE = "github.com/lessonnine/*";
    };
  };
}
