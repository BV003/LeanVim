vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local gitsigns = require("gitsigns")
gitsigns.setup()

local M = {}

local function current_gitdir()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (vim.bo.buftype == "" and file ~= "") and vim.fs.dirname(file) or vim.fn.getcwd()
  if vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.getcwd()
  end
  local r = vim.system({ "git", "-C", dir, "rev-parse", "--absolute-git-dir" }, { text = true }):wait()
  return r.code == 0 and vim.trim(r.stdout) or nil
end

-- Panel buffers are named gitsigns-diff://<gitdir>//<tab>; match by gitdir when given.
local function find_panel(wins, gitdir)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "gitsigns-diff"
      and (not gitdir or vim.api.nvim_buf_get_name(buf):find("gitsigns-diff://" .. gitdir .. "//", 1, true))
    then
      return win
    end
  end
end

-- Close via the panel's own `q`, then return to the tab we came from.
local function close_panel(panel)
  local prev = vim.fn.tabpagenr("#")
  local prev_tab = prev > 0 and vim.api.nvim_list_tabpages()[prev] or nil
  vim.api.nvim_set_current_win(panel)
  vim.cmd("normal q")
  if prev_tab and vim.api.nvim_tabpage_is_valid(prev_tab) then
    vim.api.nvim_set_current_tabpage(prev_tab)
  end
end

function M.close_panel_in_tab()
  local panel = find_panel(vim.api.nvim_tabpage_list_wins(0))
  if panel then
    close_panel(panel)
  end
end

vim.keymap.set("n", "<leader>g", function()
  if vim.bo.filetype == "gitsigns-diff" then
    return close_panel(vim.api.nvim_get_current_win())
  end

  local gitdir = current_gitdir()
  if not gitdir then
    return vim.notify("Not in a git repo (switch to a project with Space p first)", vim.log.levels.WARN)
  end

  local panel = find_panel(vim.api.nvim_list_wins(), gitdir)
  if panel then
    vim.api.nvim_set_current_win(panel)
  else
    gitsigns.diff(nil, nil, { diff = "unified" })
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
