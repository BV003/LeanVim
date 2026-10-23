-- 启动页：mini.starter（类似 VSCode 的欢迎页）
-- 仓库：https://github.com/nvim-mini/mini.starter
-- 直接运行 nvim（不带文件）时自动显示；页面上按名字的首字母执行对应操作
vim.pack.add({
  "https://github.com/nvim-mini/mini.starter",
})

local starter = require("mini.starter")
local fzf = require("fzf-lua")

starter.setup({
  header = "NVIM",
  footer = "",
  evaluate_single = true,     -- 输入的字母只匹配到一项时直接执行
  items = {
    -- 切换项目复用 fzf-lua.lua 里的 空格 p
    { name = "p  Projects",       action = function() vim.api.nvim_feedkeys(vim.keycode("<leader>p"), "m", false) end, section = "" },
    { name = "f  Files",          action = fzf.files,                     section = "" },
    { name = "r  Recent files",   action = fzf.oldfiles,                  section = "" },
    { name = "g  Grep content",   action = fzf.live_grep,                 section = "" },
    { name = "e  Explorer",       action = "Neotree toggle",              section = "" },
    { name = "c  Config",         action = function() vim.cmd.cd("~/.config/nvim"); fzf.files() end, section = "" },
    { name = "q  Quit",           action = "qa",                          section = "" },
  },
  content_hooks = {
    starter.gen_hook.adding_bullet("  "),
    starter.gen_hook.aligning("center", "center"),
  },
})

-- 空格 h：回到启动页（home）
vim.keymap.set("n", "<leader>h", starter.open, { desc = "启动页" })
