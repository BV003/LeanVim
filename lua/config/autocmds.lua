-- Autocommands: run automatically when an event fires
-- List all events: :help events
local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Check whether files were changed externally (e.g. an AI agent in another terminal); works with autoread in options.lua
-- Fires when: returning to the nvim window, switching files, or after being idle for updatetime (250ms)
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() == "" then   -- checktime can't run in the command-line window
      vim.cmd("checktime")
    end
  end,
})

-- Notify after a file is reloaded, so the change doesn't go unnoticed
autocmd("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("File changed externally, reloaded: " .. vim.fn.fnamemodify(args.file, ":t"), vim.log.levels.INFO)
  end,
})

-- Briefly highlight yanked text
autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- When reopening a file, return the cursor to its last position
autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Some languages use 2-space indentation
autocmd("FileType", {
  group = group,
  pattern = { "lua", "javascript", "typescript", "html", "css", "json", "yaml", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
