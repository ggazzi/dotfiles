-- Ensure we can backspace freely in insert mode
vim.o.backspace = "indent,eol,start"

-- Check the first two lines of each file for a modeline
vim.o.modeline = true
vim.o.modelines = 2

-- Enable statusbar and ruler
vim.o.laststatus = 2
vim.o.ruler = true

-- Use spaces instead of tabs
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Use one space after period
vim.o.joinspaces = false

-- Make sure files are auto-saved and loaded all the time
vim.o.autowriteall = true
vim.o.autoread = true
vim.o.hidden = true
vim.o.updatetime = 200
vim.cmd [[autocmd FocusLost * silent! wall]]
vim.cmd [[autocmd BufHidden * silent! write]]

-- We don't need swapfiles/recovery if we're saving all the time
vim.o.swapfile = false

-- Enable syntax highlighting
vim.cmd [[syntax on]]

-- Auto-detect filetypes and use this to load plugins and indent files
vim.cmd [[filetype indent plugin on]]

-- Configure a long enough undo history
vim.o.undolevels = 1000

-- Improve the search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Indent soft-wrapped lines property
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2"

-- Configure folding by indent, nothing folded by default
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.foldenable = false

-- Use nice colors
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme "catppuccin"

-- Make sure the cursor is far enough away from window border
vim.o.scrolloff = 5

-- Make sure we have enough time for key sequences, but not too much
vim.o.timeoutlen = 1000
