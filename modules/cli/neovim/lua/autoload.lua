-- Load all configs in autoload directory
for _, conf in ipairs(vim.fn.split(vim.fn.globpath("~/.config/nvim/lua/autoload", "*.lua"), "\n")) do
  vim.cmd.luafile(conf)
end
