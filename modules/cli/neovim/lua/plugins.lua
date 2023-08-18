return {
  -- Sensible defaults
  "tpope/vim-sensible",

  -- Nice colour theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Contextual configuration
  { "folke/neoconf.nvim", config = true }, -- neovim config per project/directory
  "editorconfig/editorconfig-vim", -- editor-agnostic config per directory
  "tpope/vim-sleuth", -- detect tabstop and shiftwidth automatically

  -- Make keymaps more usable and discoverable
  { "folke/which-key.nvim", config = true }, -- popup to help navigate chords
  "sunaku/vim-shortcut", -- make shortcuts searchable

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
      },
      'williamboman/mason-lspconfig.nvim',

      -- Status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy' },

      -- Additional configuration for neovim lua plugin development
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp', -- engine that accepts multiple sources
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source
      'onsails/lspkind.nvim', -- icons for lsp
      'saadparwaiz1/cmp_luasnip', -- snippets source
      'L3MON4D3/LuaSnip', -- snippets plugin
    },
  },

  -- Linters
  "dense-analysis/ale",

  -- Fuzzy finders and pickers
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Integration with git
  'lewis6991/gitsigns.nvim', -- much more than just signs for line changes

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
  },

  -- Smarter editing commands
  "AndrewRadev/sideways.vim", -- move items left and right in lists
  "AndrewRadev/splitjoin.vim", -- switch between single- and multiline expressions/statements
  "godlygeek/tabular", -- align text in multiple lines
  { 'numToStr/Comment.nvim', config = true }, -- manipulation of comments
  "tpope/vim-repeat", -- make sure the repeat key '.' works well with the following
  "tpope/vim-abolish", -- case-coercion; case-smart substitution
  "tpope/vim-capslock", -- soft-capslock
  "tpope/vim-surround", -- operate on surrounding pairs (parens, quotes, tags...)
  "Tummetott/unimpaired.nvim", -- commands that come in pairs bound to '[X' and ']X'
  'wellle/targets.vim', -- additional "targets" (pairs, quotes, arguments...)

  -- Open files into specific locations if :line:col suffix is given
  "kopischke/vim-fetch",

  -- Highlight trailing whitespace
  "ntpeters/vim-better-whitespace",

  -- Shortcuts to unix commands
  "tpope/vim-eunuch",

  -- Close buffers without messing up the windows
  "moll/vim-bbye",
}
