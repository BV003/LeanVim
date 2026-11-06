local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Close window" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split left/right" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split top/bottom" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down one line" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up one line" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down one line" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up one line" })
map("i", "<Down>", "<C-o>gj", { desc = "Move down one line" })
map("i", "<Up>", "<C-o>gk", { desc = "Move up one line" })

map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
