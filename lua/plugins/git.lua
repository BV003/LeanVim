vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local gitsigns = require("gitsigns")
gitsigns.setup()

local function find_panel()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-diff" then
      return win
    end
  end
end

local function in_git_repo()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (vim.bo.buftype == "" and file ~= "") and vim.fs.dirname(file) or vim.fn.getcwd()
  if vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.getcwd()
  end
  return vim.system({ "git", "-C", dir, "rev-parse", "--git-dir" }):wait().code == 0
end

vim.keymap.set("n", "<leader>g", function()
  if vim.bo.filetype == "gitsigns-diff" then
    vim.cmd("normal q")
    return
  end

  local panel = find_panel()
  if panel then
    vim.api.nvim_set_current_win(panel)
  elseif in_git_repo() then
    gitsigns.diff(nil, nil, { diff = "unified" })
  else
    vim.notify("Not in a git repo (switch to a project with Space p first)", vim.log.levels.WARN)
  end
end, { desc = "Git changes panel" })
