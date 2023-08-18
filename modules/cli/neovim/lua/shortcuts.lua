-- Helper function to map a key/chord
--
-- ## Options:
--   - silent (default: true)
--   - no_cr (default: false)
--   - modes (default: 'n')
local function map(chord, command, description, options)
  options = options or {}
  local silent = options.silent == nil and true or options.silent
  local no_cr = options.no_cr or false
  local modes = options.modes or {'n'}

  if not no_cr and not command:match('^<Plug>') then
    command = command .. '<CR>'
  end

  for _, mode in ipairs(modes) do
    vim.api.nvim_set_keymap(mode, chord, command, {noremap = true, silent = silent, desc = description})
  end
end

-- Trigger auto-completion
vim.api.nvim_set_keymap('i', '<C-Space>', 'pumvisible() ? "\\<C-n>" : "\\<Cmd>lua require(\'cmp\').complete()<CR>"', {expr = true, noremap = true, silent = true})


-- Buffer management (depends on vim-bbye)
map('<Leader>bc', ':let @+=expand("%")', 'Copy relative filename to clipboard', { silent = false })
map('<Leader>bC', ':let @+=expand("%:p")', 'Copy absolute filename to clipboard', { silent = false })
map('<Leader>bd', ':Bwipeout', 'Wipeout current buffer keeping window layout')
map('<Leader>bl', ':b#', 'Switch to last used buffer')
map('<Leader>bo', ':%bd \\| :e #', 'Close all other buffers')
map('<Leader>bD', ':bwipeout', 'Wipeout current buffer')

-- Window management
map('<Leader>ws', ':split', 'Split window horizontally')
map('<Leader>wv', ':vsplit', 'Split window vertically')
map('<Leader>wh', '<C-w>h', 'Jump to window on the left')
map('<Leader>wj', '<C-w>j', 'Jump to window below')
map('<Leader>wk', '<C-w>k', 'Jump to window above')
map('<Leader>wl', '<C-w>l', 'Jump to window on the right')
map('<Leader>wH', '<C-w>H', 'Swap window with next to the left')
map('<Leader>wJ', '<C-w>J', 'Swap window with next below')
map('<Leader>wK', '<C-w>K', 'Swap window with next above')
map('<Leader>wL', '<C-w>L', 'Swap window with next to the right')
map('<Leader>wp', '<C-w>p', 'Jump to previous (last accessed) window')
map('<Leader>wq', '<C-w>q', 'Close current window')
-- map('<Leader>wo', '???', 'Close all other windows')
map('<Leader>w=', '<C-w>=', 'Equalize size of windows')
map('<Leader>w-', '<C-w>-', 'Decrease window height')
map('<Leader>w+', '<C-w>+', 'Increase window height')
map('<Leader>w<lt>', '<C-w><lt>', 'Decrease window height')
map('<Leader>w>', '<C-w>>', 'Increase window height')

-- Fuzzy finder (depends on telescope.nvim)
map('<Leader>fb', ':Telescope buffers', 'Find buffer')
map('<Leader>fc', ':Telescope commands', 'Find command')
map('<Leader>fd', ':Telescope diagnostics', 'Find diagnostics')
map('<Leader>ff', ':Telescope find_files hidden=true', 'Find files')
map('<Leader>fg', ':Telescope live_grep', 'Find files')
map('<Leader>fh', ':Telescope help_tags', 'Find help tags')
map('<Leader>fm', ':Telescope keymaps', 'Find keymaps')
map('<Leader>f/', ':Telescope current_buffer_fuzzy_find', 'Find in current buffer')

-- Navigation
map('ge', 'G', 'Last line')
map(']w', ':NextTrailingWhitespace', 'Next trailing whitespace')
map('[w', ':PrevTrailingWhitespace', 'Previous trailing whitespace')

-- Git integration (depends on plugins I don't have)
-- map('<Leader>gb', ':Git blame', 'Activate git blame for current buffer')
-- map('<Leader>gB', ':GBrowse', 'Browse current file in git repository', { modes = {'n', 'v'} })
-- map('<Leader>gq', ':GLoadChanged', 'Git: load modified files into quickfix')
-- map('<Leader>gr', ':silent ! hub browse', 'Browse current branch in git repository')

-- Spell-checking
map('<Leader>se', ':setlocal spell spelllang=en_gb', 'Enable spellcheck for English')
map('<Leader>sn', ':setlocal nospell', 'Disable spellcheck')
map('<Leader>sp', ':setlocal spell spelllang=pt_br', 'Enable spellcheck for Portuguese')
map('<Leader>sd', ':setlocal spell spelllang=de', 'Enable spellcheck for German')

-- highlight
map('*', ":let @/='\\<<C-R>=expand(\"<cword>\")<CR>\\>'<CR>:set hls", 'Highlight word under cursor')

-- format JSON
-- map('<Leader>fj', ':%!jq .', 'Format JSON')

-- arguments
-- map('<Leader>aH', ':SidewaysLeft', 'Move current argument to the left')
-- map('<Leader>aL', ':SidewaysRight', 'Move current argument to the right')

-- other shortcuts
-- map('<Leader>dg', ':call OpenGithubRepo()', 'Open Github repo in current line on the Browser')

-- lighttree
-- map('<leader>nf', ':Lighttree reveal', 'Find current file in Lighttree')
-- map('<Leader>nn', ':noh', 'Disable search highlight') -- disable search highlight
-- map('<leader>ns', ':vsplit<CR>:Lighttree', 'Open Lighttree in a vertical split')
-- map('<leader>nt', ':Lighttree', 'Open Lighttree in current window')

-- terminal runner
-- map('<Leader>vb', ':call TermRun("bundle install")', 'Run bundler')
-- map('<Leader>vc', ':call TermRun(runner#cached())', 'Test: Run tests for cached files in git')
-- map('<Leader>vl', ':call TermRun(runner#last())', 'Test: Rerun last command')
-- map('<Leader>vo', ':call TermToggle()', 'Test: Toggle runner')
-- map('<Leader>vq', ':call TermRun(runner#quickfix())', 'Test: Run tests for files in quickfix')
-- map('<leader>vt', ':call TermRun(runner#nearest())', 'Test: Run current test')
-- map('<Leader>vx', ':call TermInterrupt()', 'Test: Interrupt runner')
-- map('<leader>vL', ':call TermRun(getline("."))', 'Test: Send current line to terminal')
-- map('<leader>vT', ':call TermRun(runner#file())', 'Test: Run tests for current file')

