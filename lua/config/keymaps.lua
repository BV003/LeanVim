-- 快捷键（相当于 VSCode 的 keybindings.json）
-- 格式：vim.keymap.set(模式, 按键, 动作, { desc = 说明 })
-- 模式："n" 普通模式  "i" 插入模式  "v" 可视模式  "t" 终端模式
-- <leader> 是空格键（在 init.lua 中设置）
local map = vim.keymap.set

-- 保存 / 退出
map("n", "<leader>w", "<cmd>w<cr>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "关闭窗口" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "保存文件（VSCode 习惯）" })

-- 按 Esc 清除搜索高亮
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "清除搜索高亮" })

-- 在分屏窗口之间移动：Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "移到左边窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "移到下边窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "移到上边窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "移到右边窗口" })

-- 分屏
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "左右分屏" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "上下分屏" })

-- 可视模式下缩进后保持选中，可以连续按 > 或 <
map("v", "<", "<gv", { desc = "向左缩进" })
map("v", ">", ">gv", { desc = "向右缩进" })

-- 可视模式下用 J/K 上下移动选中的行（类似 VSCode 的 Alt+↑/↓）
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "选中行下移" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "选中行上移" })

-- 内置终端：按 Esc Esc 退出终端的输入模式
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "退出终端模式" })
