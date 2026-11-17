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

-- 外部修改（同 VSCode）：无未保存修改 → 静默重载；
-- 有未保存修改 → 保留你的版本，保存时 nvim 会再确认；被删除 → 只提示。
autocmd("FileChangedShell", {
  group = group,
  callback = function(args)
    local name = vim.fn.fnamemodify(args.file, ":t")
    local reason = vim.v.fcs_reason
    if reason == "changed" then
      vim.v.fcs_choice = "reload"
    elseif reason == "conflict" then
      vim.notify(name .. " changed on disk; kept your unsaved edits (:e! to load disk version)", vim.log.levels.WARN)
    elseif reason == "deleted" then
      vim.notify(name .. " was deleted on disk", vim.log.levels.WARN)
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

-- 含中文的文件关掉 linebreak：linebreak 只在空格/标点处折行，中文里会提前折行、留下大片空白；
-- 关掉后中文按字折行排满一行（英文单词偶尔会被切开）。只检查前 200 行，结果按 buffer 缓存。
local cjk = vim.regex([=[[\u3000-\u303f\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uac00-\ud7af\uff00-\uffef]]=])

autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    vim.b[args.buf].has_cjk = nil
  end,
})

autocmd("BufWinEnter", {
  group = group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    if vim.b[args.buf].has_cjk == nil then
      local text = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, 200, false), "\n")
      vim.b[args.buf].has_cjk = cjk:match_str(text) ~= nil
    end
    vim.opt_local.linebreak = not vim.b[args.buf].has_cjk
  end,
})
