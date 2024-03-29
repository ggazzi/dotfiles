-- Utilities for creating keybindings that come in pairs or toggle things on and off.

local wk = require('which-key')

local M = {}

wk.register {
  ['['] = { name = '+Backwards, disable' },
  [']'] = { name = '+Forwards, enable' },
  ['<Leader>t'] = { name = '+Toggle' },
}

local function process_defs(defs, process_single)
  local inner_iter, inner_st, initial_key = pairs(defs)

  local function iter(st, key)
    local opts
    key, opts = inner_iter(st, key)
    if key == nil then return nil end

    return key, process_single(opts, key)
  end

  return iter, inner_st, initial_key
end

local PAIR_DESCRIPTION_PATTERN = '%((.*)|(.*)%)'
local function process_pair(opts)
  local description, cmd1, cmd2 = unpack(opts)
  local description1, _ = description:gsub(PAIR_DESCRIPTION_PATTERN, '%1')
  local description2, _ = description:gsub(PAIR_DESCRIPTION_PATTERN, '%2')
  return { cmd1, description1 }, { cmd2, description2 }
end

-- Register pairs of commands that are triggered by pressing `[key` and `]key`.
--
-- The argument `pair_defs` must be a table of keybindings with the form
-- `{ [key] = { description, cmd1, cmd }, ... }` where:
--   - `description` is a string describing the pair. It may contain patterns
--     of the form `(foo|bar)` which will be used to generate the descriptions
--     by choosing `foo` for `[key` and `bar` for `]key`.
--   - `cmd1` and `cmd2` are the commands to run when `[key` and `]key`
--      are pressed, respectively.
function M.register_pairs(pair_defs, opts)
  local bindings = {}

  for key, binding1, binding2 in process_defs(pair_defs, process_pair) do
    bindings['[' .. key] = binding1
    bindings[']' .. key] = binding2
  end

  wk.register(bindings, opts or { noremap = false })
end

local function process_toggle(opts, key)
  local description, turn_on, turn_off, toggle
  if #opts == 1 and type(opts.option) == 'string' then
    -- case `{description, option}` where `option` is a global vim option
    local option
    description, option = unpack(opts)
    turn_on = function() vim.o[option] = true end
    turn_off = function() vim.o[option] = false end
    toggle = function() vim.o[option] = not vim.o[option] end
  elseif #opts == 2 then
    -- case `{description, toggle}` where `toggle` is a command
    --   we return early due to missing bindings for `[key` and `]key`
    description, toggle = unpack(opts)
    return { toggle, 'Toggle ' .. description }
  elseif #opts == 3 and type(opts.is_on) == 'function' then
    -- case `{description, turn_on, turn_off, is_on = function}`
    --   where `turn_on` and `turn_off` are commands
    local is_on = opts.is_on
    description, turn_on, turn_off = unpack(opts)
    toggle = function() if is_on() then turn_off() else turn_on() end end
  elseif #opts == 4 then
    -- case `{description, turn_on, turn_off, toggle}`
    --   where `turn_on`, `turn_off` and `toggle` are commands
    description, turn_on, turn_off, toggle = unpack(opts)
  else
    error(string.format('Invalid toggle definition for "%k"', key))
  end

  return
      { toggle, 'Toggle ' .. description },
      { turn_on, 'Enable ' .. description },
      { turn_off, 'Disable ' .. description }
end

-- Registers options that can be turned on and off with `[key` and `]key` or
-- toggled with `<Leader>t key`.
--
-- The argument `toggle_defs` must be a table of keybindings with the form
-- `{ [key] = options, ... }` where `options` is either:
--
--  - a table of the form `{ description, option = string }`
--  where `option` is a global boolean option.
--
--  - a table of the form `{ description, toggle }` where `toggle` is a
--  command. In this case, bindings for `[key` and `]key` will not be created.
--
--  - a table of the form `{ description, turn_on, turn_off, is_on = function }`
--  where `turn_on` and `turn_off` are commands. In this case, toggle will
--  check the value of `is_on` to determine whether to turn the option on or
--  off.
--
--  - a table of the form `{ description, turn_on, turn_off, toggle }` where
--  where `turn_on`, `turn_off` and `toggle` are commands.
function M.register_toggles(toggle_defs, opts)
  local bindings = {}

  for key, binding_toggle, binding_on, binding_off in process_defs(
    toggle_defs,
    process_toggle
  ) do
    if binding_toggle then bindings['<Leader>t' .. key] = binding_toggle end
    if binding_off then bindings['[' .. key] = binding_off end
    if binding_on then bindings[']' .. key] = binding_on end
  end

  wk.register(bindings, opts or { noremap = false })
end

return M
