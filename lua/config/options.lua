local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

-- 自动换行：在单词间折行，折行保持缩进（Space z 切换）
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.swapfile = false
opt.confirm = true

opt.updatetime = 250
