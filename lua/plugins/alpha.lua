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
  dashboard.button("c", "> search contents", "<cmd>FzfLua live_grep<cr>"),
  dashboard.button("r", "> recent files", "<cmd>FzfLua oldfiles<cr>"),
  dashboard.button("p", "> switch project", " p"),   -- Same as pressing Space p
  dashboard.button("e", "> file tree", "<cmd>Neotree toggle<cr>"),
  dashboard.button("q", "> quit", "<cmd>qa<cr>"),
}

-- Footer: nvim version
local v = vim.version()
dashboard.section.footer.val = string.format("~ nvim v%d.%d.%d ~", v.major, v.minor, v.patch)

-- Center the content vertically: the top padding is computed from the window height (recomputed when the window is resized)
local function top_padding()
  local buttons = #dashboard.section.buttons.val * 2 - 1   -- One blank line between buttons
  local content = #dashboard.section.header.val + 2 + buttons + 1   -- header + gap + buttons + footer
  return math.max(0, math.floor((vim.fn.winheight(0) - content) / 2))
end
dashboard.config.layout[1].val = top_padding

require("alpha").setup(dashboard.config)
