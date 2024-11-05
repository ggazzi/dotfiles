{
  imports = [
    ../plugins

    ./appearance
    ./coding
    ./keys.nix
    ./navigation
  ];

  plugins = {
    lualine.enable = true;
  };
}
