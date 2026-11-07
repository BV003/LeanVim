vim.pack.add({ "https://github.com/goolord/alpha-nvim" })

local dashboard = require("alpha.themes.dashboard")
local section = dashboard.section

section.header.val = {
  "██╗     ███████╗ █████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
  "██║     ██╔════╝██╔══██╗████╗  ██║██║   ██║██║████╗ ████║",
  "██║     █████╗  ███████║██╔██╗ ██║██║   ██║██║██╔████╔██║",
  "██║     ██╔══╝  ██╔══██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "███████╗███████╗██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

section.buttons.val = {
  dashboard.button("f", "> find file", "<cmd>FzfLua files<cr>"),
  dashboard.button("c", "> search contents", "<cmd>FzfLua live_grep<cr>"),
  dashboard.button("r", "> recent files", "<cmd>FzfLua oldfiles<cr>"),
  dashboard.button("p", "> switch project", " p"),
  dashboard.button("e", "> file tree", "<cmd>Neotree toggle<cr>"),
  dashboard.button("q", "> quit", "<cmd>qa<cr>"),
}

local v = vim.version()
section.footer.val = string.format("~ nvim v%d.%d.%d ~", v.major, v.minor, v.patch)

dashboard.config.layout[1].val = function()
  local content = #section.header.val + 2 + (#section.buttons.val * 2 - 1) + 1
  return math.max(0, math.floor((vim.fn.winheight(0) - content) / 2))
end

require("alpha").setup(dashboard.config)
