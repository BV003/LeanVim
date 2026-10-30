-- Fuzzy search: fzf-lua (like VSCode's Ctrl+P and global search)
-- Repo: https://github.com/ibhagwan/fzf-lua
-- Requires CLI tools: fzf (required), fd (file names), rg (file contents)
vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
})

require("fzf-lua").setup({
  -- No Nerd Font installed for now, so don't show file icons
  defaults = {
    file_icons = false,
    git_icons = false,
  },
})

local fzf = require("fzf-lua")
local map = vim.keymap.set

-- Search file names (like Ctrl+P); ignores files in .gitignore by default
map("n", "<leader><leader>", fzf.files, { desc = "Search files" })
map("n", "<leader>ff", fzf.files, { desc = "Search files" })

-- Search the contents of all files (like Ctrl+Shift+F), updating as you type
map("n", "<leader>/", fzf.live_grep, { desc = "Search contents" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Search contents" })

-- Search open files
map("n", "<leader>fb", fzf.buffers, { desc = "Open files" })

-- Recently opened files
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })

-- Search the word under the cursor
map("n", "<leader>fw", fzf.grep_cword, { desc = "Search word under cursor" })

-- Resume the last search
map("n", "<leader>fR", fzf.resume, { desc = "Resume last search" })

-- Switch project: lists the nvim config directory plus projects set in this machine's lua/config/local.lua
-- local.lua only holds paths specific to this machine and is gitignored; if missing, only the nvim config directory is listed
-- On selection, change the working directory (later searches and the file tree follow it) and open file search
map("n", "<leader>p", function()
  local ok, local_config = pcall(require, "config.local")
  if not ok then
    local_config = {}
  end

  local projects = {}
  -- Each subdirectory of a project_roots directory counts as a project
  for _, root in ipairs(local_config.project_roots or {}) do
    for _, dir in ipairs(vim.fn.globpath(root, "*/", false, true)) do
      table.insert(projects, vim.fn.fnamemodify(dir:gsub("/$", ""), ":~"))
    end
  end
  table.insert(projects, "~/.config/nvim")
  -- projects holds individually added projects
  for _, dir in ipairs(local_config.projects or {}) do
    table.insert(projects, dir)
  end

  fzf.fzf_exec(projects, {
    prompt = "Project> ",
    actions = {
      ["enter"] = function(selected)
        vim.cmd.cd(selected[1])
        fzf.files()
      end,
    },
  })
end, { desc = "Switch project" })
