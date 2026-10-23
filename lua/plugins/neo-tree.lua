-- 文件树：neo-tree（类似 VSCode 左侧资源管理器）
-- 仓库：https://github.com/nvim-neo-tree/neo-tree.nvim
-- vim.pack 是 nvim 0.12 自带的插件管理器，插件安装在 ~/.local/share/nvim/site/pack/core/opt/
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",          -- 依赖：常用 Lua 工具函数
  "https://github.com/MunifTanjim/nui.nvim",           -- 依赖：UI 组件
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

require("neo-tree").setup({
  close_if_last_window = true,     -- 只剩文件树时自动退出 nvim
  popup_border_style = "rounded",

  -- 当前没有安装 Nerd Font，图标先用普通字符
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
    follow_current_file = { enabled = true },   -- 切换文件时，树自动定位到当前文件
    use_libuv_file_watcher = true,              -- 磁盘上文件变化时自动刷新
    hijack_netrw_behavior = "open_current",     -- nvim . 打开目录时用 neo-tree 代替 netrw
    filtered_items = {
      hide_dotfiles = false,                    -- 显示 .gitignore 等点文件
      hide_gitignored = true,
    },
  },
})

-- 空格 e：打开/关闭文件树（类似 VSCode 的 Ctrl+B）
-- 平时用模糊搜索打开文件（见 fzf-lua.lua），需要看目录结构或新建文件时再打开文件树
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "文件树" })

-- 空格 g：打开/关闭 Git 改动列表（类似 VSCode 的源代码管理面板，含新建的文件）
-- 列表内：A 暂存全部，ga/gu 暂存/取消暂存，gr 撤销改动，gg 提交并推送
vim.keymap.set("n", "<leader>g", "<cmd>Neotree toggle git_status<cr>", { desc = "Git 改动列表" })
