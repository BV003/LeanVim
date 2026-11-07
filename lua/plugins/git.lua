vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local gitsigns = require("gitsigns")
gitsigns.setup()

local M = {}

local function find_panel(wins)
  for _, win in ipairs(wins) do
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

function M.close_panel_in_tab()
  local panel = find_panel(vim.api.nvim_tabpage_list_wins(0))
  if not panel then
    return
  end
  local prev = vim.fn.tabpagenr("#")
  local prev_tab = prev > 0 and vim.api.nvim_list_tabpages()[prev] or nil
  vim.api.nvim_set_current_win(panel)
  vim.cmd("normal q")
  if prev_tab and vim.api.nvim_tabpage_is_valid(prev_tab) then
    vim.api.nvim_set_current_tabpage(prev_tab)
  end
end

vim.keymap.set("n", "<leader>g", function()
  if vim.bo.filetype == "gitsigns-diff" then
    vim.cmd("normal q")
    return
  end

  local panel = find_panel(vim.api.nvim_list_wins())
  if panel then
    vim.api.nvim_set_current_win(panel)
  elseif in_git_repo() then
    gitsigns.diff(nil, nil, { diff = "unified" })
  else
    vim.notify("Not in a git repo (switch to a project with Space p first)", vim.log.levels.WARN)
  end
end, { desc = "Git changes panel" })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_git_panel", { clear = true }),
  pattern = "gitsigns-diff",
  callback = function(args)
    vim.schedule(function()
      pcall(vim.keymap.del, "n", "<Space>", { buffer = args.buf })
    end)
  end,
})

return M
