vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.shiftwidth = 0
vim.opt.tabstop = 2

vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.signcolumn = "yes"

require'nvim-treesitter.configs'.setup {
  highlight = { enable = true, },
}
require'gitsigns'.setup()
require'lualine'.setup()
require'Comment'.setup()
