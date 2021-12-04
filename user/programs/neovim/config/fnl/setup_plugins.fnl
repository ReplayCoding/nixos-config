(fn setup_packages [use]
  (use :wbthomason/packer.nvim)
  (use :lewis6991/impatient.nvim)

  (use {1 :numToStr/Comment.nvim
        :config (fn []
                 ((. (require :Comment) :setup)))})

  (use {1 :hrsh7th/vim-vsnip
        :after :nvim-cmp
        :setup (fn []
                (vim.api.nvim_set_keymap "i" "<C-Tab>"   "vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-Tab>'"   {:expr true})
                (vim.api.nvim_set_keymap "s" "<C-Tab>"   "vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-Tab>'"   {:expr true})
                (vim.api.nvim_set_keymap "i" "<S-Tab>"   "vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'" {:expr true})
                (vim.api.nvim_set_keymap "s" "<S-Tab>"   "vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'" {:expr true}))})

  (use {1 :hrsh7th/nvim-cmp
        :event :InsertEnter
        :requires [
                  {1 :hrsh7th/cmp-vsnip :after :nvim-cmp}
                  {1 :hrsh7th/cmp-buffer :after :nvim-cmp}
                  {1 :hrsh7th/cmp-path :after :nvim-cmp}
                  {1 :hrsh7th/cmp-nvim-lsp :module :cmp_nvim_lsp}
                  [:rafamadriz/friendly-snippets]]
        :config (. (require :plugs.cmp) :config)})

  (use {1 :akinsho/toggleterm.nvim
        :keys [[:n :<leader>g]]
        :setup (. (require :plugs.toggleterm) :setup)
        :config (. (require :plugs.toggleterm) :config)})

  (use {1 :folke/tokyonight.nvim
        :event :UIEnter
        :setup (fn []
                (set vim.g.tokyonight_style :night)
                (set vim.g.tokyonight_italic_functions true)
                (set vim.opt.termguicolors true))
        :config (fn []
                (vim.cmd "colorscheme tokyonight"))})

  (use {1 :ahmedkhalf/project.nvim
        :requires :telescope.nvim
        :config (fn []
                ((. (require :project_nvim) :setup)))})

  (use {1 :lewis6991/gitsigns.nvim
        :event :BufRead
        :requires [:nvim-lua/plenary.nvim]
        :config (. (require :plugs.gitsigns) :config)})

  (use {1 :nvim-lua/lsp-status.nvim
        :module :lsp-status
        :config (. (require :plugs.lsp-status) :config)})

  (use {1 :nvim-lua/plenary.nvim
          :module :plenary})

  (use {1 :kyazdani42/nvim-web-devicons
          :module :nvim-web-devicons})

  (use {1 :nvim-lualine/lualine.nvim
        :event :UIEnter
        :requires :kyazdani42/nvim-web-devicons
        :after [:tokyonight.nvim]
        :config (. (require :plugs.lualine) :config)})

  (use {1 :kyazdani42/nvim-tree.lua
        :cmd "NvimTreeToggle"
        :requires :kyazdani42/nvim-web-devicons
        :setup (. (require :plugs.nvim-tree) :setup)
        :config (. (require :plugs.nvim-tree) :config)})

  (use {1 :neovim/nvim-lspconfig
        :config (. (require :plugs.lspconfig) :config)})

  (use {1 "nvim-telescope/telescope-fzf-native.nvim" :run :make})
  (use {1 :nvim-telescope/telescope.nvim
        :cmd :Telescope
        :module :telescope
        :after "telescope-fzf-native.nvim"
        :requires [:nvim-lua/plenary.nvim]
        :setup (. (require :plugs.telescope) :setup)
        :config (. (require :plugs.telescope) :config)})

  (use {1 :nvim-treesitter/nvim-treesitter
        :run ":TSUpdate"
        :config (. (require :plugs.treesitter) :config)})

  (use {1 :ggandor/lightspeed.nvim
          :keys [[:n "s"]
                 [:n "S"]
                 [:x "s"]
                 [:x "S"]
                 [:o "z"]
                 [:o "Z"]

                 [:o "x"]
                 [:o "X"]

                 [:n "f"]
                 [:n "F"]
                 [:x "f"]
                 [:x "F"]
                 [:o "f"]
                 [:o "F"]

                 [:n "t"]
                 [:n "T"]
                 [:x "t"]
                 [:x "T"]
                 [:o "t"]
                 [:o "T"]]}))

(let [packer (require :packer)]
  (packer.reset)
  (setup_packages packer.use))
