-- Start page: alpha-nvim (shown when running nvim with no file)
-- Repo: https://github.com/goolord/alpha-nvim
vim.pack.add({
  "https://github.com/goolord/alpha-nvim",
})

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

-- Buttons: press the letter on the left to run; same functions as the usual keymaps
dashboard.section.buttons.val = {
  dashboard.button("f", "> find file", "<cmd>FzfLua files<cr>"),
  dashboard.button("g", "> grep text", "<cmd>FzfLua live_grep<cr>"),
  dashboard.button("r", "> recent files", "<cmd>FzfLua oldfiles<cr>"),
  dashboard.button("p", "> switch project", " p"),   -- Same as pressing Space p
  dashboard.button("e", "> file tree", "<cmd>Neotree toggle<cr>"),
  dashboard.button("q", "> quit", "<cmd>qa<cr>"),
}

-- Footer: nvim version
local v = vim.version()
dashboard.section.footer.val = string.format("~ nvim v%d.%d.%d ~", v.major, v.minor, v.patch)

require("alpha").setup(dashboard.config)
