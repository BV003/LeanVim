-- Keymaps (equivalent to VSCode's keybindings.json)
-- Format: vim.keymap.set(mode, key, action, { desc = description })
-- Modes: "n" normal  "i" insert  "v" visual  "t" terminal
-- <leader> is the space key (set in init.lua)
local map = vim.keymap.set

-- Save / quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Close window" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file (VSCode habit)" })

-- Press Esc to clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Move between split windows: Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splits
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split left/right" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split top/bottom" })

-- Keep the selection after indenting in visual mode, so > or < can be repeated
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- On wrapped lines, j/k and ↑/↓ move by screen line (like VSCode); with a count (e.g. 5j) they still move by real line
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down one line" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up one line" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down one line" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up one line" })
map("i", "<Down>", "<C-o>gj", { desc = "Move down one line" })
map("i", "<Up>", "<C-o>gk", { desc = "Move up one line" })

-- Use J/K in visual mode to move selected lines up/down (like VSCode's Alt+↑/↓)
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

-- Built-in terminal: press Esc Esc to leave terminal input mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
