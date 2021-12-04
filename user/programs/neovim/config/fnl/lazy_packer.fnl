(global have-we-loaded-packer-yet false)

;; Using underscores to ensure global naming
(global _wrapper_packer_function
        (fn [function ...]
          (if (not have-we-loaded-packer-yet)
              (require :setup_plugins))
          (set _G.have-we-loaded-packer-yet true)
          ((. (require :packer) function) ...)))

((. (require :packer) :init) {:display {:open_fn (fn []
                                                   ((. (require :packer.util)
                                                       :float) {:border :shadow}))}
                              :disable_commands true})

(vim.cmd "command! PackerInstall           lua _wrapper_packer_function('install')")
(vim.cmd "command! PackerUpdate            lua _wrapper_packer_function('update')")
(vim.cmd "command! PackerSync              lua _wrapper_packer_function('sync')")
(vim.cmd "command! PackerClean             lua _wrapper_packer_function('clean')")
(vim.cmd "command! -nargs=* PackerCompile  lua _wrapper_packer_function('compile', <q-args>)")
(vim.cmd "command! PackerStatus            lua _wrapper_packer_function('status')")
(vim.cmd "command! PackerProfile           lua _wrapper_packer_function('profile_output')")
(vim.cmd "command! -nargs=+ -complete=customlist,v:lua.require'packer'.loader_complete PackerLoad lua _wrapper_packer_function('loader', <q-args>)")
