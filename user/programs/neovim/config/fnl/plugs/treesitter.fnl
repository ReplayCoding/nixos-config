(fn config []
  (let [setup (. (require :nvim-treesitter.configs) :setup)]
    (setup {:ensure_installed :maintained
            :highlight {:enable true}
            :indent {:enable true}})))

{: config}
