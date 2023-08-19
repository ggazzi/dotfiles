local wk = require('which-key');
local tp = require('toggles_and_pairs');

-- Trigger auto-completion
vim.api.nvim_set_keymap('i', '<C-Space>', 'pumvisible() ? "\\<C-n>" : "\\<Cmd>lua require(\'cmp\').complete()<CR>"',
  { expr = true, noremap = true, silent = true })


-- Buffer management (depends on vim-bbye)
wk.register({
  name = '+Buffer',
  c = { ':let @+=expand("%")<CR>', 'Copy relative filename to clipboard', silent = false },
  C = { ':let @+=expand("%:p")<CR>', 'Copy absolute filename to clipboard', silent = false },
  d = { ':Bwipeout<CR>', 'Wipeout current buffer keeping window layout' },
  l = { ':b#<CR>', 'Switch to last used buffer' },
  o = { ':%bd \\| :e #<CR>', 'Close all other buffers' },
  D = { ':bwipeout<CR>', 'Wipeout current buffer' },
}, { prefix = '<Leader>b' })

-- Window management
wk.register({
  name = '+Window',
  s = { ':split<CR>', 'Split window horizontally' },
  v = { ':vsplit<CR>', 'Split window vertically' },
  h = { '<C-w>h', 'Jump to window on the left' },
  j = { '<C-w>j', 'Jump to window below' },
  k = { '<C-w>k', 'Jump to window above' },
  l = { '<C-w>l', 'Jump to window on the right' },
  H = { '<C-w>H', 'Swap window with next to the left' },
  J = { '<C-w>J', 'Swap window with next below' },
  K = { '<C-w>K', 'Swap window with next above' },
  L = { '<C-w>L', 'Swap window with next to the right' },
  p = { '<C-w>p', 'Jump to previous (last accessed) window' },
  q = { '<C-w>q', 'Close current window' },
  -- TODO: o = { '???', 'Close all other windows' },
  ['='] = { '<C-w>=', 'Equalize size of windows' },
  ['-'] = { '<C-w>-', 'Decrease window height' },
  ['+'] = { '<C-w>+', 'Increase window height' },
  ['<'] = { '<C-w><lt>', 'Decrease window height' },
  ['>'] = { '<C-w>>', 'Increase window height' },
}, { prefix = '<Leader>w' })

-- Fuzzy finder (depends on telescope.nvim)
wk.register({
  name = '+Find (fuzzy)',
  b = { ':Telescope buffers<CR>', 'Find buffer' },
  c = { ':Telescope commands<CR>', 'Find command' },
  d = { ':Telescope diagnostics<CR>', 'Find diagnostics' },
  f = { ':Telescope find_files hidden=true<CR>', 'Find files' },
  g = { ':Telescope live_grep<CR>', 'Find files' },
  h = { ':Telescope help_tags<CR>', 'Find help tags' },
  m = { ':Telescope keymaps<CR>', 'Find keymaps' },
  ['/'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'Find in current buffer' },
}, { prefix = '<Leader>f' })

-- Navigation
wk.register({
  name = '+Go to',
  h = { '^', 'Start of line' },
  l = { '$', 'End of line' },
  g = 'First line',
  e = { 'G', 'Last line' },
  ['%'] = 'Matching brackets',
  i = 'Last insertion (and insert mode)',
  v = 'Last selection (and visual mode)',
  f = 'File under cursor',
  -- TODO: bind 'gF' to open file externally
  n = 'Next search result',
  N = 'which_key_ignore',
  P = { 'GN', 'Previous search result' },

  -- TODO: figure out who maps the following and remove those mappings
  ['~'] = 'which_key_ignore',
  u = 'which_key_ignore',
  U = 'which_key_ignore',
}, { prefix = 'g', noremap = false })
-- TODO: map 'gX' for visual mode too

for _, chord in ipairs({ 'C', 'F' }) do
  wk.register({ g = { [chord] = 'which_key_ignore' } })
  local status, err = pcall(function() vim.api.nvim_del_keymap('n', 'g' .. chord) end)
  if not status then
    print(string.format('WARN: cannot remove mapping for "g%s": %s', chord, err))
  end
end

-- Commands that come in pairs
-- TODO: find a better version of this
require('unimpaired').setup {}

tp.register_toggles({
  C = { 'soft Caps lock',
    '<Plug>CapsLockEnable',
    '<Plug>CapsLockDisable',
    '<Plug>CapsLockToggle',
  },
  n = {
    'line numbers',
    -- When enabling, turn only absolute line numbers on
    function() vim.o.number, vim.o.relativenumber = true, false end,
    -- When disabling, turn both absolute and relative line numbers off
    function() vim.o.number, vim.o.relativenumber = false, false end,
    -- It's only considered on when relative numbers are not
    is_on = function() return vim.o.number and not vim.o.relativenumber end,
  },
  N = {
    'relative line numbers',
    -- When enabling, turn both absolute and relative line numbers on
    function() vim.o.number, vim.o.relativenumber = true, true end,
    -- When disabling, turn only relative line numbers off
    function() vim.o.relativenumber = false end,
    -- It's considered on regardless of absolute line numbers
    is_on = function() return vim.o.relativenumber end,
  },
})

-- Code
require('treesj').setup { use_default_keymaps = false }
wk.register({
  name = "+Code",
  s = { ':TSJSplit<CR>', 'Split into multiline expression/statement' },
  j = { ':TSJJoin<CR>', 'Join into single line expression/statement' },
  d = {
    name = "+Diagnostics",
    d = { vim.diagnostic.open_float, 'Open diagnostics in float window' },
    q = { vim.diagnostic.setloclist, 'Open diagnostics in quickfix list' },
  },
  c = {
    name = "+Comments",
    l = 'Toggle line comments (takes target)',
    b = 'Toggle block comments (takes target)',
  },
  C = {
    name = "+Copilot",
    e = { ':Copilot enable<CR>', 'Enable Copilot' },
    d = { ':Copilot disable<CR>', 'Disable Copilot' },
    s = { ':Copilot status<CR>', 'Show Copilot status' },
    C = { ':Copilot panel<CR>', 'Show panel with up to 10 completions' },
  },
}, { prefix = '<Leader>c', noremap = false })

tp.register_pairs({
  d = {
    'Go to (previous|next) diagnostic',
    vim.diagnostic.goto_prev,
    vim.diagnostic.goto_next,
  },
})

-- Git integration (depends on plugins I don't have)
-- map('<Leader>gb', ':Git blame', 'Activate git blame for current buffer')
-- map('<Leader>gB', ':GBrowse', 'Browse current file in git repository', { modes = {'n', 'v'} })
-- map('<Leader>gq', ':GLoadChanged', 'Git: load modified files into quickfix')
-- map('<Leader>gr', ':silent ! hub browse', 'Browse current branch in git repository')

-- Spell-checking
wk.register({
  name = '+Spell checking',
  e = { ':setlocal spell spelllang=en_gb<CR>', 'Enable spellcheck for English' },
  n = { ':setlocal nospell<CR>', 'Disable spellcheck' },
  p = { ':setlocal spell spelllang=pt_br<CR>', 'Enable spellcheck for Portuguese' },
  d = { ':setlocal spell spelllang=de<CR>', 'Enable spellcheck for German' },
}, { prefix = '<Leader>s' })

-- highlight
wk.register({
  ['*'] = { ":let @/='\\<<C-R>=expand(\"<cword>\")<CR>\\>'<CR>:set hlsearch<CR>", 'Highlight word under cursor' },
  ['<Ctrl>*'] = { ':set nohlsearch<CR>', 'Disable highlighted word' },
})

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
