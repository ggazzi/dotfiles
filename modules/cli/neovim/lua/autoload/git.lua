local wk = require('which-key')

wk.register {
  ['<Leader>g'] = { name = '+Git' },
  ['<Leader>tg'] = { name = '+Git' },
}

require('gitsigns').setup {
  on_attach = function(bufnr)
    local tp = require('toggles_and_pairs')
    local gs = package.loaded.gitsigns

    -- Toggles
    tp.register_toggles({
      gb = { 'current line blame', gs.toggle_current_line_blame },
      gd = { 'deleted lines', gs.toggle_deleted },
      gw = { 'word diff', gs.toggle_word_diff },
      gl = { 'line highlighting', gs.toggle_linehl },
      gn = { 'line number highlighting', gs.toggle_numhl },
    }, { buffer = bufnr, noremap = false })

    -- Actions
    wk.register({
      s = { gs.stage_hunk, 'Stage hunk' },
      S = { gs.stage_buffer, 'Stage buffer' },
      u = { gs.undo_stage_hunk, 'Unstage hunk' },
      r = { gs.reset_hunk, 'Reset hunk' },
      R = { gs.reset_buffer, 'Reset buffer' },
      p = { gs.preview_hunk, 'Preview hunk' },
      b = { gs.blame_line, 'Blame line' },
      B = { function() gs.blame_line{full=true} end, 'Blame line (full info)' },
    }, { prefix = '<Leader>g', buffer = bufnr, noremap = false })

    -- Navigation
    tp.register_pairs({
      h = { 'Go to (previous|next) hunk', gs.prev_hunk, gs.next_hunk },
    }, { buffer = bufnr, noremap = false })

    -- Text object
    wk.register({
      ih = { gs.select_hunk, 'Select hunk' },
    }, { mode = {'o', 'x'}, buffer = bufnr, noremap = false })
  end
}

local neogit = require('neogit')
neogit.setup()
wk.register({
  g = { neogit.open, 'Open Neogit' },
  c = { function() neogit.open({ "commit" }) end, 'Commit with Neogit' },

}, { prefix = '<Leader>g', noremap = false })
