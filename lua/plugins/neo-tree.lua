vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
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
    mappings = { ["<space>"] = "none" },
  },
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    hijack_netrw_behavior = "open_current",
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

vim.cmd([[
  nmenu 1.1 PopUp.New\ File     a
  nmenu 1.2 PopUp.New\ Folder   A
  nmenu 1.3 PopUp.Rename        r
  nmenu 1.4 PopUp.-tree-sep-    <Nop>
  nmenu 1.5 PopUp.Delete\ File  d
]])

local tree_items = { [[New\ File]], [[New\ Folder]], [[Rename]], [[-tree-sep-]], [[Delete\ File]] }
local default_items = {
  [[Inspect]], [[-1-]], [[Cut]], [[Copy]], [[Paste]], [[Delete]], [[Select\ All]], [[-2-]], [[How-to\ disable\ mouse]],
}
local conditional_items = {
  [[Open\ in\ web\ browser]], [[Go\ to\ definition]], [[Show\ Diagnostics]], [[Show\ All\ Diagnostics]], [[Configure\ Diagnostics]],
}

local function set_menu(items, enabled)
  for _, item in ipairs(items) do
    vim.cmd("silent! amenu " .. (enabled and "enable" or "disable") .. " PopUp." .. item)
  end
end

vim.api.nvim_create_autocmd("MenuPopup", {
  group = vim.api.nvim_create_augroup("user_neotree_popup", { clear = true }),
  callback = function()
    local in_tree = vim.bo.filetype == "neo-tree"
    set_menu(tree_items, in_tree)
    set_menu(default_items, not in_tree)
    if in_tree then
      set_menu(conditional_items, false)
    end
  end,
})

vim.keymap.set("n", "<leader>e", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd("Neotree close")
  else
    vim.cmd("Neotree focus")
  end
end, { desc = "File tree" })
