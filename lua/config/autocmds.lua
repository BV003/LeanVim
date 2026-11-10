local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- 外部修改时不弹 OK/Load 提示，直接加载磁盘版本；
-- 若有未保存修改，重载可用 u 撤销找回（undoreload）。
autocmd("FileChangedShell", {
  group = group,
  callback = function()
    if vim.v.fcs_reason == "changed" or vim.v.fcs_reason == "conflict" then
      vim.v.fcs_choice = "reload"
    end
  end,
})

autocmd("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("File changed externally, reloaded: " .. vim.fn.fnamemodify(args.file, ":t"))
  end,
})

autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("FileType", {
  group = group,
  pattern = { "lua", "javascript", "typescript", "html", "css", "json", "yaml", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
