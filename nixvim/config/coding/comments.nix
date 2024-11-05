{
  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>m"; group = "Comment"; mode = [ "n" "v" ]; }
  ];

  plugins.comment = {
    enable = true;

    settings = {
      opleader = {
        line = "<leader>ml";
        block = "<leader>mb";
      };
      toggler = {
        line = "<leader>mll";
        block = "<leader>mbb";
      };
      extra = {
        above = "<leader>mlO";
        below = "<leader>mlB";
        eol = "<leader>mlA";
      };
    };
  };
}
