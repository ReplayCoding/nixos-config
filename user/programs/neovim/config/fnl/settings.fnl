(local disabled_built_ins [:netrw
                           :netrwPlugin
                           :netrwSettings
                           :netrwFileHandlers
                           :gzip
                           :zip
                           :zipPlugin
                           :tar
                           :tarPlugin
                           :getscript
                           :getscriptPlugin
                           :vimball
                           :vimballPlugin
                           :2html_plugin
                           :logipat
                           :rrhelper
                           :spellfile_plugin
                           :matchit])

(each [_ plugin (ipairs disabled_built_ins)]
  (tset vim.g (.. :loaded_ plugin) 1))

(set vim.opt.number true)
(set vim.opt.expandtab true)
(set vim.opt.shiftwidth 2)
(set vim.opt.wrap false)
(set vim.opt.cursorline true)
(set vim.opt.relativenumber true)
(set vim.opt.shortmess :filnxtToOFI)
(set vim.opt.signcolumn :yes)
(set vim.opt.shada "")

(set vim.g.mapleader "\\")
