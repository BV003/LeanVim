-- 单一递归文件监听：外部改动 → 过滤 → 节流 → checktime + `User FsChanged`。
-- 视图（neo-tree、git 面板）只订阅 FsChanged，不各自监听文件系统。
local uv = vim.uv
local M = {}

local DELAY = 200 -- 首个事件后等多久再刷新，合并同一批写入
local MIN_INTERVAL = 500 -- 两次刷新的最小间隔，防止构建/安装时刷新风暴
local SELF_WRITE_TTL = 1000 -- nvim 自己写入后这段时间内的同路径事件视为回声

-- libuv 只在 macOS(FSEvents) 和 Windows 上支持递归监听；其他平台退化为定时 checktime。
M.supported = vim.fn.has("mac") == 1 or vim.fn.has("win32") == 1

local ignored = {
  "/%.git/objects/", "/%.git/logs/", "/node_modules/",
  "%.lock$", "/%.DS_Store$", "%.swp$", "~$", "/4913$",
}

local handle, poll, root
local pending, self_writes = {}, {}
local scheduled, last_flush = false, 0

local function checktime()
  if vim.fn.getcmdwintype() == "" then
    pcall(vim.cmd.checktime)
  end
end

local function flush()
  scheduled = false
  last_flush = uv.now()

  local files = {}
  for file in pairs(pending) do
    local t = self_writes[file]
    if not (t and last_flush - t < SELF_WRITE_TTL) then
      files[#files + 1] = file
    end
  end
  pending = {}
  for file, t in pairs(self_writes) do
    if last_flush - t >= SELF_WRITE_TTL then
      self_writes[file] = nil
    end
  end
  if #files == 0 then
    return
  end

  checktime()
  vim.api.nvim_exec_autocmds("User", {
    pattern = "FsChanged",
    modeline = false,
    data = { root = root, files = files },
  })
end

-- 在 libuv 回调（fast context）里执行：只做字符串处理和计时器调度。
local function on_event(err, fname)
  if err then
    return
  end
  local rel = fname or ""
  local probe = "/" .. rel
  for _, pattern in ipairs(ignored) do
    if probe:find(pattern) then
      return
    end
  end
  pending[rel == "" and root or root .. "/" .. rel] = true
  if not scheduled then
    scheduled = true
    local wait = math.max(DELAY, last_flush + MIN_INTERVAL - uv.now())
    vim.defer_fn(flush, wait)
  end
end

function M.stop()
  if handle then
    handle:stop()
    handle:close()
    handle = nil
  end
  if poll then
    poll:stop()
    poll:close()
    poll = nil
  end
  pending = {}
end

function M.start(dir)
  M.stop()

  if not M.supported then
    poll = uv.new_timer()
    poll:start(1000, 1000, vim.schedule_wrap(checktime))
    return
  end

  dir = uv.fs_realpath(vim.fs.normalize(dir)) or dir
  root = vim.fs.root(dir, ".git") or dir
  -- 不递归监听整个 home 或根目录
  if root == uv.os_homedir() or root == "/" then
    return
  end

  handle = uv.new_fs_event()
  local ok, err = handle:start(root, { recursive = true }, on_event)
  if not ok then
    handle:close()
    handle = nil
    vim.notify("File watcher failed on " .. root .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end

local group = vim.api.nvim_create_augroup("user_watch", { clear = true })

vim.api.nvim_create_autocmd("DirChanged", {
  group = group,
  callback = function()
    M.start(vim.fn.getcwd())
  end,
})
M.start(vim.fn.getcwd())

vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = M.stop })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  callback = function(args)
    local file = uv.fs_realpath(args.file)
    if file then
      self_writes[file] = uv.now()
    end
  end,
})

return M
