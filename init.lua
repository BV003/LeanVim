-- Neovim config entry point: the first file executed at startup
-- Only loads the modules in order; actual settings live under lua/config/

-- The leader key must be set before any keymaps are defined
vim.g.mapleader = " "       -- Space as the leader key
vim.g.maplocalleader = "\\"

require("config.options")   -- Load lua/config/options.lua
require("config.keymaps")   -- Load lua/config/keymaps.lua
require("config.autocmds")  -- Load lua/config/autocmds.lua

-- Plugins: one file per plugin, under lua/plugins/
require("plugins.kanagawa")    -- Load the theme first so later plugin UIs pick up its colors
require("plugins.lualine")     -- Bottom status line
require("plugins.alpha")       -- Start page
require("plugins.neo-tree")
require("plugins.fzf-lua")
require("plugins.git")         -- gitsigns + diffview
