vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })

require("kanagawa").setup({ dimInactive = true })
vim.cmd.colorscheme("kanagawa-wave")
