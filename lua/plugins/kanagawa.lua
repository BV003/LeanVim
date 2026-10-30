-- Theme: Kanagawa (inspired by Hokusai's The Great Wave off Kanagawa, with soft colors)
-- Repo: https://github.com/rebelot/kanagawa.nvim
vim.pack.add({
  "https://github.com/rebelot/kanagawa.nvim",
})

require("kanagawa").setup({
  dimInactive = true,   -- Dim unfocused splits so the current window stands out
})

-- Options: kanagawa-wave (default dark) / kanagawa-dragon (darker) / kanagawa-lotus (light)
vim.cmd.colorscheme("kanagawa-wave")
