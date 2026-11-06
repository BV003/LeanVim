vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf = require("fzf-lua")
local map = vim.keymap.set

fzf.setup({
  defaults = {
    file_icons = false,
    git_icons = false,
  },
})

map("n", "<leader>f", fzf.files, { desc = "Find files" })
map("n", "<leader>c", fzf.live_grep, { desc = "Search contents" })
map("n", "<leader>r", fzf.oldfiles, { desc = "Recent files" })

local function list_projects()
  local ok, config = pcall(require, "config.local")
  if not ok then
    config = {}
  end

  local projects = {}
  for _, root in ipairs(config.project_roots or {}) do
    for _, dir in ipairs(vim.fn.globpath(root, "*/", false, true)) do
      table.insert(projects, vim.fn.fnamemodify((dir:gsub("/$", "")), ":~"))
    end
  end
  table.insert(projects, "~/.config/nvim")
  vim.list_extend(projects, config.projects or {})
  return projects
end

map("n", "<leader>p", function()
  fzf.fzf_exec(list_projects(), {
    prompt = "Project> ",
    actions = {
      ["enter"] = function(selected)
        vim.cmd.cd(selected[1])
        fzf.files()
      end,
    },
  })
end, { desc = "Switch project" })
