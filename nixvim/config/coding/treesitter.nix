{
  plugins.treesitter = {
    enable = true;

    settings = {
      auto_install = true;

      highlight.enable = true;
      indent.enable = true;

      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = false;
          node_decremental = "gnN";
          node_incremental = "gnn";
          scope_incremental = "gns";
        };
      };
    };
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "gn"; mode = "v"; group = "Incremental selection (treesitter)"; }
    { __unkeyed-1 = "gnN"; mode = "v"; desc = "Node decremental"; }
    { __unkeyed-1 = "gnn"; mode = "v"; desc = "Node incremental"; }
    { __unkeyed-1 = "gns"; mode = "v"; desc = "Scope incremental"; }
  ];
}
