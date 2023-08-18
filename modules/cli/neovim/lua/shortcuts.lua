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

local wk = require('which-key');

-- Trigger auto-completion
vim.api.nvim_set_keymap('i', '<C-Space>', 'pumvisible() ? "\\<C-n>" : "\\<Cmd>lua require(\'cmp\').complete()<CR>"', {expr = true, noremap = true, silent = true})


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
    -- o = { '???', 'Close all other windows' },
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

for _, chord in ipairs({
    'b', -- TODO: map something to comment toggle (blockwise)
    'c', -- TODO: map something to comment toggle (linewise)
    'C', -- TODO: map soft capslock
    'F',
    'J', -- TODO: map something to "join lines"
    'S', -- TODO: map something to this
}) do
    wk.register({ g = { [chord] = 'which_key_ignore' } })
    local status, err = pcall(function() vim.api.nvim_del_keymap('n', 'g' .. chord) end)
    if not status then
        print(string.format('WARN: cannot remove mapping for "g%s": %s', chord, err))
    end
end

wk.register({
    [']'] = { name = '+Go to next' },
    ['['] = { name = '+Go to previous' },
})
local nav_pairs = {
    w = { 'trailing whitespace', ':NextTrailingWhitespace', ':PrevTrailingWhitespace' },
}
for key, def in pairs(nav_pairs) do
    if type(def) == 'string' then
        wk.register({
            [']'] = { [key] = 'Next ' .. def },
            ['['] = { [key] = 'Previous ' .. def },
        })
    else
        wk.register({
            [']'] = { [key] = { def[2], 'Next ' .. def[1] } },
            ['['] = { [key] = { def[3], 'Previous ' .. def[1] } },
        })
    end
end

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

