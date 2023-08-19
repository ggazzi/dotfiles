require('lualine').setup {
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = { },
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'location' },
    lualine_z = { },
  },
}
