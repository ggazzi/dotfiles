{ mylib, ... }:

{
  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "g"; group = "Go to"; }
    { __unkeyed-1 = "<leader>gi"; desc = "Last insertion (and insert mode)"; }
    { __unkeyed-1 = "<leader>gg"; desc = "First line"; }
    { __unkeyed-1 = "<leader>g%"; desc = "Matching brackets"; }
    { __unkeyed-1 = "<leader>gi"; desc = "Last insertion (and insert mode)"; }
    { __unkeyed-1 = "<leader>gv"; desc = "Last selection (and visual mode)"; }
    { __unkeyed-1 = "<leader>gf"; desc = "File under cursor"; }
    { __unkeyed-1 = "<leader>gn"; desc = "Next search result"; }
    { __unkeyed-1 = "<leader>gN"; desc = "which_key_ignore"; }

    # TODO: figure out who maps the following and remove those mappings
    #{ __unkeyed-1 = "<leader>g~"; desc = "which_key_ignore"; }
    #{ __unkeyed-1 = "<leader>gu"; desc = "which_key_ignore"; }
    #{ __unkeyed-1 = "<leader>gU"; desc = "which_key_ignore"; }
  ];

  keymaps = mylib.keymapGroup "<leader>g" [
    { key = "h"; action = "^"; options.desc = "Start of line"; }
    { key = "l"; action = "$"; options.desc = "End of line"; }
    { key = "e"; action = "G"; options.desc = "Last line"; }
    # TODO: bind 'gF' to open file externally
    { key = "P"; action = "GN"; options.desc = "Previous search result"; }
  ];
}
