-- Git, kept as simple as VSCode's, all with gitsigns:
--   1. Colored bars next to line numbers show which lines changed
--   2. Space g opens the changes panel; click a file to see its changes in one screen
--      (deleted lines in red, added lines in green, like VSCode's inline diff)
-- Repo: https://github.com/lewis6991/gitsigns.nvim
vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
})

require("gitsigns").setup()

-- Space g: changes panel (like VSCode's Source Control view), works like Space e for the file tree
--   In the panel's file list: close the panel
--   Panel already open (e.g. you are reading a file in it): jump back to the file list
--   Otherwise: open the panel (in its own tab; repo found from the current file, or else the working directory)
vim.keymap.set("n", "<leader>g", function()
  if vim.bo.filetype == "gitsigns-diff" then
    vim.cmd("normal q")   -- The panel's own close key
    return
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-diff" then
      vim.api.nvim_set_current_win(win)   -- Also switches to the panel's tab
      return
    end
  end

  -- Not in a repo: show a short hint instead of git's raw error
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (vim.bo.buftype == "" and file ~= "") and vim.fs.dirname(file) or vim.fn.getcwd()
  if vim.fn.isdirectory(dir) == 0 then dir = vim.fn.getcwd() end
  if vim.system({ "git", "-C", dir, "rev-parse", "--git-dir" }):wait().code ~= 0 then
    vim.notify("Not in a git repo (switch to a project with Space p first)", vim.log.levels.WARN)
    return
  end
  require("gitsigns").diff(nil, nil, { diff = "unified" })
end, { desc = "Git changes panel" })
