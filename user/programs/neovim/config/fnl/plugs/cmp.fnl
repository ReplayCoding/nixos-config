(fn config [] (let [cmp (require :cmp)]
  (cmp.setup {
    :formatting {
      :format (fn [entry vim-item]
        (set vim-item.menu (. {
          :buffer "[Buffer]"
          :nvim_lsp "[LSP]"
          :luasnip "[LuaSnip]"
          :nvim_lua "[Lua]"
          :latex_symbols "[Latex]"
        } entry.source.name))
        vim-item
      )
    }
    :snippet {
      :expand (fn [args] ((. vim.fn "vsnip#anonymous") args.body))
    }
    :mapping {
      :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace :select true})
      :<C-e> (cmp.mapping.close)
      :<C-Space> (cmp.mapping.complete)
    }
    :sources [
      {:name :nvim_lsp }
      {:name :vsnip}
      {:name :buffer}
      {:name :path}
    ]
  }))
)

{:config config}
