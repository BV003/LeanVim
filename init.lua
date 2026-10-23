-- Neovim 配置入口：启动时第一个执行的文件
-- 这里只负责按顺序加载各个模块，具体设置写在 lua/config/ 下

-- leader 键必须在定义任何快捷键之前设置
vim.g.mapleader = " "       -- 空格作为 leader 键
vim.g.maplocalleader = "\\"

require("config.options")   -- 加载 lua/config/options.lua
require("config.keymaps")   -- 加载 lua/config/keymaps.lua
require("config.autocmds")  -- 加载 lua/config/autocmds.lua

-- 插件：每个插件一个文件，放在 lua/plugins/ 下
require("plugins.neo-tree")
require("plugins.fzf-lua")
require("plugins.starter")
