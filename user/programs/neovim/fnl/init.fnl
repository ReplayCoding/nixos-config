(set vim.opt.expandtab true)
(set vim.opt.smarttab true)

(set vim.opt.shiftwidth 0)
(set vim.opt.tabstop 2)

(set vim.opt.termguicolors true)

(set vim.opt.number true)
(set vim.opt.signcolumn :yes)

((. (require :nvim-treesitter.configs) :setup) {:highlight {:enable true}
                                                :indent {:enable true}})
((. (. (require :lspconfig) :pyright) :setup) {})

((. (require :gitsigns) :setup))
((. (require :lualine) :setup))
((. (require :Comment) :setup))

((. (require :catppuccin) :setup))
(vim.cmd "colorscheme catppuccin")
