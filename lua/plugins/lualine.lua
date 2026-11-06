vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

require("lualine").setup({
  options = {
    theme = "auto",
    icons_enabled = false,
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { { "mode", fmt = function(s) return "[" .. s .. "]" end } },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { { "location", fmt = function(s) return "ln " .. s end } },
  },
})
