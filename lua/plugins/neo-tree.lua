vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

require("neo-tree").setup({
  close_if_last_window = true,
  use_popups_for_input = false,
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
    mappings = {
      ["<space>"] = "none",
      ["Y"] = function(state)
        local path = state.tree:get_node():get_id()
        vim.fn.setreg("+", path)
      end,
    },
  },
  filesystem = {
    follow_current_file = { enabled = true },
    -- 有全局递归 watcher 时改由 User FsChanged 驱动，避免两套监听
    use_libuv_file_watcher = not require("config.watch").supported,
    hijack_netrw_behavior = "open_current",
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

-- 树的右键菜单：{ 文字, 触发的 neo-tree 按键 }，要加菜单项就加在这里
local tree_menu = {
  { "New File", "a" },
  { "New Folder", "A" },
  { "Rename", "r" },
  { "Copy Path", "Y" },
  { "Delete File", "d" },
}

-- 鼠标在树上右键 → 光标移到点击的节点，在鼠标旁弹出菜单；其他位置保持默认右键
vim.keymap.set({ "n", "i" }, "<RightMouse>", function()
  local pos = vim.fn.getmousepos()
  if pos.winid == 0 or vim.bo[vim.api.nvim_win_get_buf(pos.winid)].filetype ~= "neo-tree" then
    return "<RightMouse>"
  end
  vim.schedule(function()
    vim.cmd.stopinsert()
    vim.api.nvim_set_current_win(pos.winid)
    if pos.line > 0 then
      vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 0 })
    end
    require("config.popup").show("NeoTree", vim.tbl_map(function(item)
      return { item[1], function() vim.api.nvim_feedkeys(item[2], "m", false) end }
    end, tree_menu))
  end)
  return ""
end, { expr = true, desc = "File tree menu" })

vim.keymap.set("n", "<leader>e", function()
  local closed_panel = require("plugins.git").close_panel_in_tab()
  vim.cmd(closed_panel and "Neotree focus" or "Neotree toggle")
end, { desc = "File tree" })

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("user_neotree_fs", { clear = true }),
  pattern = "FsChanged",
  callback = function()
    -- 只刷新当前 tab 中可见的树；refresh 会同时重算 git 状态
    require("neo-tree.sources.manager").refresh("filesystem")
  end,
})
