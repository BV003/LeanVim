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
      hide_gitignored = false,                  -- Show gitignored files, dimmed (like VSCode); searches still skip them
    },
  },
})

-- Right-click menu for the file tree (like VSCode's Explorer context menu)
-- Uses nvim's built-in right-click menu "PopUp": right-click moves the cursor to the clicked item, then shows the menu
-- Each item presses the matching neo-tree key; new items go inside the clicked folder (or next to the clicked file)
local tree_items = { [[New\ File]], [[New\ Folder]], [[Rename]], [[-tree-sep-]], [[Delete\ File]] }
vim.cmd([[
  nmenu 1.1 PopUp.New\ File     a
  nmenu 1.2 PopUp.New\ Folder   A
  nmenu 1.3 PopUp.Rename        r
  nmenu 1.4 PopUp.-tree-sep-    <Nop>
  nmenu 1.5 PopUp.Delete\ File  d
]])

-- nvim's default PopUp items (hidden inside the file tree, shown everywhere else)
-- Items that nvim itself shows only in some cases (Go to definition, Open in web browser...) are left to nvim
local default_items = {
  [[Inspect]], [[-1-]], [[Cut]], [[Copy]], [[Paste]], [[Delete]], [[Select\ All]], [[-2-]], [[How-to\ disable\ mouse]],
  [[Open\ in\ web\ browser]], [[Go\ to\ definition]], [[Show\ Diagnostics]], [[Show\ All\ Diagnostics]], [[Configure\ Diagnostics]],
}

-- Just before the menu shows: in the file tree show only file actions; elsewhere hide them
-- Disabled items are not shown in the menu
vim.api.nvim_create_autocmd("MenuPopup", {
  group = vim.api.nvim_create_augroup("user_neotree_popup", { clear = true }),
  callback = function()
    local in_tree = vim.bo.filetype == "neo-tree"
    for _, item in ipairs(tree_items) do
      vim.cmd("silent! amenu " .. (in_tree and "enable" or "disable") .. " PopUp." .. item)
    end
    for i, item in ipairs(default_items) do
      if in_tree then
        vim.cmd("silent! amenu disable PopUp." .. item)
      elseif i <= 9 then   -- The always-on defaults; the conditional ones nvim has already set
        vim.cmd("silent! amenu enable PopUp." .. item)
      end
    end
  end,
})

-- Space e: file tree (like VSCode's Ctrl+Shift+E)
-- Normally open files with fuzzy search (see fzf-lua.lua); use the tree to view the directory structure or create files
-- In a file: jump to the tree (opening it if needed); already in the tree: close it
vim.keymap.set("n", "<leader>e", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd("Neotree close")
  else
    vim.cmd("Neotree focus")
  end
end, { desc = "File tree" })
