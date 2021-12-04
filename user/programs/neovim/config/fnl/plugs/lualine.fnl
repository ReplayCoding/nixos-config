(fn config []
  ((. (require :lualine) :setup) {:options {:theme :tokyonight
                                            :section_separators ""
                                            :component_separators ""
                                            :disabled_filetypes [:packer
                                                                 :NvimTree]}
                                  :sections {:lualine_a [:mode]
                                             :lualine_b [{1 :filename
                                                          :file_status true
                                                          :path 1}]
                                             :lualine_c [(. (require :lsp-status)
                                                            :status)]
                                             :lualine_x [{1 :diagnostics
                                                          :sources [:nvim_lsp]}]
                                             :lualine_y [:encoding]
                                             :lualine_z [:location]}}))

{: config}
