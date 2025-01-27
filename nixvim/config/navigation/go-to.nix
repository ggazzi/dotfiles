{ mylib, ... }:

{
  # Process line and column specifications when jumping to file paths,
  # in the form of `file:line:column`.
  plugins.vim-fetch.enable = true;

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "g"; group = "Go to"; mode = [ "n" "v" ]; }
    { __unkeyed-1 = "gi"; desc = "Last insertion (and insert mode)"; }
    { __unkeyed-1 = "gg"; desc = "First line"; }
    { __unkeyed-1 = "g%"; desc = "Matching brackets"; }
    { __unkeyed-1 = "gi"; desc = "Last insertion (and insert mode)"; }
    { __unkeyed-1 = "gv"; desc = "Last selection (and visual mode)"; }
    { __unkeyed-1 = "gf"; desc = "File under cursor"; }
    { __unkeyed-1 = "gn"; desc = "Next search result"; }
    { __unkeyed-1 = "gN"; desc = "which_key_ignore"; }

    # TODO: figure out who maps the following and remove those mappings
    { __unkeyed-1 = "g~"; desc = "which_key_ignore"; }
    { __unkeyed-1 = "gu"; desc = "which_key_ignore"; }
    { __unkeyed-1 = "gU"; desc = "which_key_ignore"; }
  ];

  keymaps = mylib.keymapGroup "g" [
    { key = "h"; action = "^"; options.desc = "Start of line"; }
    { key = "l"; action = "$"; options.desc = "End of line"; }
    { key = "e"; action = "G"; options.desc = "Last line"; }
    # TODO: bind 'gF' to open file externally
    { key = "P"; action = "GN"; options.desc = "Previous search result"; }
  ];
}
