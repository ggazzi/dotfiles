{
  programs.nixvim = {
    plugins = {
      # Detect tabstop and shiftwidth automatically
      sleuth.enable = true;

      trim = {
        enable = true;
        settings = {
          highlight = true;
          trim_on_write = true;
          trim_trailing = true;
          trim_last_line = true;
        };
      };
    };

    opts = {
      # Use 2 spaces for indentation, by default
      expandtab = true;
      smarttab = true;
      tabstop = 2;
      shiftwidth = 2;

      # Use only one space after period/exclamation/question mark
      joinspaces = false;

      # Indent soft-wrapped lines properly
      breakindent = true;
      breakindentopt = "shift:2";
    };
  };
}
