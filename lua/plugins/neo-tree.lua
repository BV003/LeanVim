-- File tree: neo-tree (like VSCode's Explorer sidebar)
-- Repo: https://github.com/nvim-neo-tree/neo-tree.nvim
-- vim.pack is the plugin manager built into nvim 0.12; plugins are installed in ~/.local/share/nvim/site/pack/core/opt/
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",          -- Dependency: common Lua utility functions
  "https://github.com/MunifTanjim/nui.nvim",           -- Dependency: UI components
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

require("neo-tree").setup({
  close_if_last_window = true,     -- Quit nvim automatically when only the file tree is left
  popup_border_style = "rounded",

  -- No Nerd Font installed for now, so use plain characters as icons
  default_component_configs = {
    icon = {
      folder_closed = "▸",
      folder_open = "▾",
      folder_empty = "▹",
      default = " ",
    },
    git_status = {
      symbols = {
        added = "A", modified = "M", deleted = "D", renamed = "R",
        untracked = "?", ignored = "◌", unstaged = "U", staged = "S", conflict = "!",
      },
    },
  },

  window = {
    width = 30,
  },

  filesystem = {
    follow_current_file = { enabled = true },   -- Reveal the current file in the tree when switching files
    use_libuv_file_watcher = true,              -- Refresh automatically when files change on disk
    hijack_netrw_behavior = "open_current",     -- Use neo-tree instead of netrw for directories (nvim .)
    filtered_items = {
      hide_dotfiles = false,                    -- Show dotfiles such as .gitignore
      hide_gitignored = true,
    },
  },
})

-- Space e: toggle the file tree (like VSCode's Ctrl+B)
-- Normally open files with fuzzy search (see fzf-lua.lua); use the tree to view the directory structure or create files
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "File tree" })
