-- Status line: lualine (shows mode, git branch, file name, cursor position, etc. at the bottom)
-- Repo: https://github.com/nvim-lualine/lualine.nvim
vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
  options = {
    theme = "auto",                  -- Automatically use kanagawa's colors
    icons_enabled = false,           -- No Nerd Font installed for now, so don't show icons
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
    globalstatus = true,             -- Show a single status line across splits
  },
  sections = {
    -- Show the mode in terminal-prompt style, e.g. [NORMAL]
    lualine_a = { { "mode", fmt = function(s) return "[" .. s .. "]" end } },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },   -- Show the relative path
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { { "location", fmt = function(s) return "ln " .. s end } },
  },
})
