-- 自动命令：某个事件发生时自动执行
-- 查看所有事件：:help events
local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- 检查文件是否被外部修改（如在另一个终端运行的 AI agent），配合 options.lua 中的 autoread
-- 触发时机：切回 nvim 窗口、切换文件、停止操作 updatetime（250ms）后
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() == "" then   -- 命令行窗口中不能执行 checktime
      vim.cmd("checktime")
    end
  end,
})

-- 文件被重新读取后提示一下，避免没注意到内容变了
autocmd("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("文件已在外部修改，已重新读取：" .. vim.fn.fnamemodify(args.file, ":t"), vim.log.levels.INFO)
  end,
})

-- 复制时短暂高亮被复制的文本
autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- 重新打开文件时，光标回到上次离开的位置
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

-- 部分语言使用 2 空格缩进
autocmd("FileType", {
  group = group,
  pattern = { "lua", "javascript", "typescript", "html", "css", "json", "yaml", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
