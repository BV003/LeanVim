vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("plugins.kanagawa")
require("plugins.lualine")
require("plugins.alpha")
require("plugins.neo-tree")
require("plugins.fzf-lua")
require("plugins.git")
