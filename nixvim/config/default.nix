{
  imports = [
    ../plugins

    ./appearance
    ./bufferline.nix
    ./coding
    ./keys.nix
    ./navigation
  ];

  plugins = {
    lualine.enable = true;
  };
}
