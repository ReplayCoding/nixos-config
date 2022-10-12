(set vim.opt.expandtab true)
(set vim.opt.smarttab true)
(set vim.opt.shiftwidth 0)
(set vim.opt.tabstop 2)

(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)

(set vim.opt.wrap false)

(set vim.opt.number true)
(set vim.opt.cursorline true)
(set vim.opt.signcolumn :yes)

(set vim.g.mapleader "\\")

((. (require :nvim-treesitter.configs) :setup) {:highlight {:enable true}
                                                :indent {:enable true}
                                                :rainbow {:enable true}})

(set vim.opt.completeopt "menu,menuone,noselect")
(let [cmp (require :cmp)]
  (cmp.setup {:formatting {:format ((. (require :lspkind) :cmp_format) {:mode :symbol})}
              :snippet {:expand (fn [args]
                                  ((. (require :luasnip) :lsp_expand) args.body))}
              :window {:documentation cmp.config.disable}
              :mapping (cmp.mapping.preset.insert {:<C-Space> (cmp.mapping.complete)
                                                   :<C-e> (cmp.mapping.abort)
                                                   :<CR> (cmp.mapping.confirm {:select true})})
              :sources (cmp.config.sources [{:name :nvim_lsp} {:name :luasnip}])
              :experimental {:ghost_text true}}))


(fn map [mode buffer lhs rhs]
  (vim.keymap.set mode lhs rhs {:noremap true :silent true : buffer}))

(map :n false :<Leader>ff "<cmd>Telescope find_files<CR>")

(let [servers [:pyright :rnix :rust_analyzer :clangd :tsserver]
      capabilities ((. (require :cmp_nvim_lsp) :update_capabilities) (vim.lsp.protocol.make_client_capabilities))
      on_attach (fn [client bufnr]
                  (map :n bufnr :gD "<cmd>lua vim.lsp.buf.declaration()<CR>")
                  (map :n bufnr :gd "<cmd>lua vim.lsp.buf.definition()<CR>")
                  (map :n bufnr :gi "<cmd>lua vim.lsp.buf.implementation()<CR>")
                  (map :n bufnr :gr "<cmd>Telescope lsp_references<CR>")
                  (map :n bufnr :K "<cmd>lua vim.lsp.buf.hover()<CR>")
                  (map :n bufnr :<Leader>lD "<cmd>lua vim.lsp.buf.type_definition()<CR>")
                  (map :n bufnr :<Leader>lr "<cmd>lua vim.lsp.buf.rename()<CR>")
                  (map :n bufnr :<Leader>la "<cmd>lua vim.lsp.buf.code_action()<CR>")
                  (map :n bufnr :<Leader>ls "<cmd>Telescope lsp_document_symbols<CR>")
                  (map :n bufnr :<Leader>lS "<cmd>Telescope lsp_workspace_symbols<CR>")
                  (map :n bufnr :<Leader>lf "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
                  (map :n bufnr :<Leader>wa "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
                  (map :n bufnr :<Leader>wr "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
                  (map :n bufnr :<Leader>wl "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"))]
  (each [_ value (ipairs servers)]
    ((. (. (require :lspconfig) value) :setup) {: on_attach : capabilities})))

((. (require :gitsigns) :setup))
((. (require :lualine) :setup))
((. (require :Comment) :setup))
((. (require :fidget) :setup))
((. (require :project_nvim) :setup))
((. (require :tokyonight) :setup) {
                                    :style :night
                                  })

(set vim.opt.termguicolors true)
(vim.cmd "colorscheme tokyonight")
