(fn setup []
  (vim.api.nvim_set_keymap :n :<leader>f :<cmd>NvimTreeToggle<CR>
                           {:silent true}))

(fn config []
  ((. (require :nvim-tree) :setup) {:auto_close true :indent_markers true}))

{: setup : config}
