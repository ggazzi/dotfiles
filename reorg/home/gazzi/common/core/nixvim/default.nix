{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./config
  ];

  programs.nixvim = {
    enable = true;
    enableMan = true;
  };
}
