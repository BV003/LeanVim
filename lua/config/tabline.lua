-- 顶部标签栏（类似 VSCode 的打开文件标签）：
--   左键切换，中键或点 ×/● 关闭，点 ◆ 取消固定，右键菜单（menu_items），滚轮左右滚动标签。
--   固定的标签排在最前，中键和 Close All 都关不掉。
--   树打开时标签从树右侧开始；放不下时围绕当前标签显示，滚动后保持滚动位置。
local api = vim.api
local M = {}

local marks = {
  close = "×",
  modified = "●",
  pinned = "◆",
  more_left = "‹ ",
  more_right = " ›",
}

local last_file -- 焦点在树/面板里时，仍高亮最近的文件
local pinned, pin_seq = {}, 0 -- bufnr → 固定先后
local scroll_first -- 滚动后首个可见标签的序号；nil 表示自动跟随当前标签
local view = { first = 1, last = 0, count = 0 } -- 上次渲染的可见范围

-- ── buffer 与窗口 ────────────────────────────────────────────

local function is_file_buf(b)
  return api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].buftype == ""
end

local function is_normal_win(w)
  return api.nvim_win_get_config(w).relative == ""
end

local function resolve(b)
  return (b and b ~= 0) and b or api.nvim_get_current_buf()
end

-- 当前高亮的标签：当前 buffer 是文件时就是它，否则是最近的文件
local function active_buf()
  local cur = api.nvim_get_current_buf()
  return is_file_buf(cur) and cur or last_file
end

-- 标签列表：固定的在前（按固定先后），其余按打开顺序。
-- 未命名且未修改的空 buffer（启动/关完标签后的占位）不算标签，除非它是当前 buffer。
local function tab_bufs()
  local cur = api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(b)
    return is_file_buf(b) and (b == cur or api.nvim_buf_get_name(b) ~= "" or vim.bo[b].modified)
  end, api.nvim_list_bufs())
  table.sort(bufs, function(a, b)
    local pa, pb = pinned[a], pinned[b]
    if pa or pb then
      return pa ~= nil and (pb == nil or pa < pb)
    end
    return a < b
  end)
  return bufs
end

local function index_of(bufs, b)
  return vim.fn.index(bufs, b) + 1 -- 0 表示不在列表中
end

-- 文件名；同名时加上父目录区分
local function labels(bufs)
  local names, count = {}, {}
  for _, b in ipairs(bufs) do
    local full = api.nvim_buf_get_name(b)
    names[b] = full == "" and "[No Name]" or vim.fn.fnamemodify(full, ":t")
    count[names[b]] = (count[names[b]] or 0) + 1
  end
  for _, b in ipairs(bufs) do
    local full = api.nvim_buf_get_name(b)
    if full ~= "" and count[names[b]] > 1 then
      names[b] = vim.fn.fnamemodify(full, ":h:t") .. "/" .. names[b]
    end
  end
  return names
end

-- 左侧文件树的宽度（含分隔线），标签从它右边开始
local function tree_offset()
  for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
    if is_normal_win(w)
      and vim.bo[api.nvim_win_get_buf(w)].filetype == "neo-tree"
      and api.nvim_win_get_position(w)[2] == 0 then
      return api.nvim_win_get_width(w) + 1
    end
  end
  return 0
end

-- 切换文件前先回到编辑窗口，避免把文件开在树或面板里
local function focus_editor()
  if is_file_buf(api.nvim_get_current_buf()) then
    return
  end
  for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
    if is_normal_win(w) and is_file_buf(api.nvim_win_get_buf(w)) then
      api.nvim_set_current_win(w)
      return
    end
  end
end

-- ── 操作 ────────────────────────────────────────────────────

function M.open(b)
  focus_editor()
  api.nvim_set_current_buf(b)
end

-- 有未保存修改时询问；返回 false 表示取消
local function confirm_save(b)
  if not vim.bo[b].modified then
    return true
  end
  local choice = vim.fn.confirm("Save changes to " .. labels({ b })[b] .. "?", "&Save\n&Don't Save\n&Cancel", 1)
  if choice == 1 then
    return (pcall(api.nvim_buf_call, b, function() vim.cmd.write() end))
  end
  return choice == 2
end

function M.close(b)
  b = resolve(b)
  if not is_file_buf(b) or not confirm_save(b) then
    return
  end

  -- 先把显示它的窗口换到相邻标签，删除 buffer 时就不会连窗口一起关掉
  local bufs = tab_bufs()
  local idx = index_of(bufs, b)
  local next_buf = bufs[idx + 1] or bufs[idx - 1]
  for _, w in ipairs(api.nvim_list_wins()) do
    if api.nvim_win_get_buf(w) == b then
      if next_buf then
        api.nvim_win_set_buf(w, next_buf)
      else
        api.nvim_win_call(w, function() vim.cmd.enew() end)
      end
    end
  end
  pcall(api.nvim_buf_delete, b, { force = true })

  if not next_buf and is_file_buf(api.nvim_get_current_buf()) and api.nvim_buf_get_name(0) == "" then
    pcall(require("alpha").start, false)
  end
end

-- 同 VSCode 的 Close All：关闭所有未固定的标签
function M.close_unpinned()
  for _, b in ipairs(tab_bufs()) do
    if not pinned[b] then
      M.close(b)
    end
  end
end

function M.toggle_pin(b)
  b = resolve(b)
  if not is_file_buf(b) then
    return
  end
  if pinned[b] then
    pinned[b] = nil
  else
    pin_seq = pin_seq + 1
    pinned[b] = pin_seq
  end
  vim.cmd.redrawtabline()
end

function M.cycle(delta)
  local bufs = tab_bufs()
  if #bufs == 0 then
    return
  end
  local idx = index_of(bufs, active_buf())
  idx = idx == 0 and 1 or (idx - 1 + delta) % #bufs + 1
  M.open(bufs[idx])
end

-- 连续滚动时在 scroll_first 上累加（重绘前 view 还没更新），越界由 render 校正
function M.scroll(delta)
  if view.first <= 1 and view.last >= view.count then
    return -- 全部放得下，无需滚动
  end
  scroll_first = math.max(1, math.min((scroll_first or view.first) + delta, view.count))
  vim.schedule(vim.cmd.redrawtabline)
end

-- 右键菜单项：{ 文字, 回调 }，要加菜单项就加在这里
local function menu_items(b)
  return {
    { pinned[b] and "Unpin" or "Pin", function() M.toggle_pin(b) end },
    { "Close All", M.close_unpinned },
  }
end

-- ── 鼠标点击（%@...@ 回调，参数：bufnr, 点击次数, 按键 l/m/r） ──

function _G.LeanTabClick(b, _, button)
  if button == "l" then
    M.open(b)
  elseif button == "m" and not pinned[b] then
    M.close(b)
  elseif button == "r" then
    require("config.popup").show("LeanTab", menu_items(b))
  end
end

-- 标签右侧的标记：× 关闭，◆ 取消固定
function _G.LeanTabMark(b, clicks, button)
  if button == "r" then
    _G.LeanTabClick(b, clicks, button)
  elseif pinned[b] then
    M.toggle_pin(b)
  else
    M.close(b)
  end
end

-- ── 渲染 ────────────────────────────────────────────────────

-- 计算可见范围：滚动过就从 start 往右排，否则以 start（当前标签）为中心；空余空间再往两边补
local function visible_range(widths, start, avail, anchored)
  local first, last, used = start, start, widths[start] or 0
  local grew = true
  while grew do
    grew = false
    if last < #widths and used + widths[last + 1] <= avail then
      last, used, grew = last + 1, used + widths[last + 1], true
    end
    if first > 1 and (not anchored or last == #widths) and used + widths[first - 1] <= avail then
      first, used, grew = first - 1, used + widths[first - 1], true
    end
  end
  return first, last
end

local function render_tab(b, name, active)
  local mark = vim.bo[b].modified and marks.modified or (pinned[b] and marks.pinned or marks.close)
  local text = table.concat({
    active and "%#LeanTabSel#" or "%#LeanTab#",
    "%", b, "@v:lua.LeanTabClick@ ", (name:gsub("%%", "%%%%")), " %X",
    "%", b, "@v:lua.LeanTabMark@", mark, " %X",
  })
  return text, vim.fn.strdisplaywidth(" " .. name .. " " .. mark .. " ")
end

-- 多个 tabpage 时在右侧显示编号
local function render_tabpages()
  local n = vim.fn.tabpagenr("$")
  if n <= 1 then
    return "", 0
  end
  local cur, parts = vim.fn.tabpagenr(), {}
  for i = 1, n do
    parts[i] = (i == cur and "%#LeanTabSel#" or "%#LeanTab#") .. "%" .. i .. "T " .. i .. " %T"
  end
  return table.concat(parts), n * 3
end

function M.render()
  local bufs = tab_bufs()
  local active = active_buf()
  local names = labels(bufs)

  local items, widths, active_idx = {}, {}, 1
  for i, b in ipairs(bufs) do
    items[i], widths[i] = render_tab(b, names[b], b == active)
    if b == active then
      active_idx = i
    end
  end

  local tabpages, tabpages_width = render_tabpages()
  local offset = tree_offset()
  local avail = vim.o.columns - offset - tabpages_width
    - vim.fn.strdisplaywidth(marks.more_left .. marks.more_right)

  local start = scroll_first and math.max(1, math.min(scroll_first, #items)) or active_idx
  local first, last = visible_range(widths, start, avail, scroll_first ~= nil)
  view = { first = first, last = last, count = #items }
  if scroll_first then
    scroll_first = first
  end

  local parts = { "%#LeanTabFill#", string.rep(" ", offset) }
  if first > 1 then
    parts[#parts + 1] = marks.more_left
  end
  vim.list_extend(parts, items, first, last)
  parts[#parts + 1] = "%#LeanTabFill#"
  if last < #items then
    parts[#parts + 1] = marks.more_right
  end
  parts[#parts + 1] = "%=" .. tabpages
  return table.concat(parts)
end

-- ── 高亮、自动命令、按键 ────────────────────────────────────

local function set_hl()
  api.nvim_set_hl(0, "LeanTab", { link = "TabLine", default = true })
  api.nvim_set_hl(0, "LeanTabSel", { link = "TabLineSel", default = true })
  api.nvim_set_hl(0, "LeanTabFill", { link = "TabLineFill", default = true })
end

-- 没有文件标签（如 dashboard）时隐藏标签栏
local function update_visibility()
  vim.o.showtabline = (#tab_bufs() > 0 or vim.fn.tabpagenr("$") > 1) and 2 or 0
end

local group = api.nvim_create_augroup("user_tabline", { clear = true })
local function on(events, opts)
  api.nvim_create_autocmd(events, vim.tbl_extend("force", { group = group }, opts))
end

on("ColorScheme", { callback = set_hl })
on("BufEnter", {
  callback = function(args)
    if is_file_buf(args.buf) then
      last_file = args.buf
      -- 切到滚出视野的标签时恢复自动跟随（同 VSCode 切换时露出当前标签）
      local idx = index_of(tab_bufs(), args.buf)
      if idx < view.first or idx > view.last then
        scroll_first = nil
      end
    end
    update_visibility()
  end,
})
on({ "BufAdd", "BufDelete", "TabNew", "TabClosed" }, {
  callback = function(args)
    if args.event == "BufDelete" then
      pinned[args.buf] = nil
    end
    vim.schedule(update_visibility)
  end,
})
on("OptionSet", { pattern = "buflisted", callback = function() vim.schedule(update_visibility) end })
on({ "BufModifiedSet", "WinResized" }, { callback = function() vim.cmd.redrawtabline() end })

set_hl()
vim.o.tabline = "%!v:lua.require'config.tabline'.render()"
update_visibility()

local map = vim.keymap.set
map("n", "<S-h>", function() M.cycle(-1) end, { desc = "Previous tab" })
map("n", "<S-l>", function() M.cycle(1) end, { desc = "Next tab" })
map("n", "<leader>x", function() M.close() end, { desc = "Close tab" })

-- 鼠标在标签栏上滚轮 → 左右滚动标签；其他位置保持默认滚动
for key, delta in pairs({
  ["<ScrollWheelUp>"] = -1, ["<ScrollWheelLeft>"] = -1,
  ["<ScrollWheelDown>"] = 1, ["<ScrollWheelRight>"] = 1,
}) do
  map({ "n", "i", "x" }, key, function()
    if vim.o.showtabline == 2 and vim.fn.getmousepos().screenrow == 1 then
      M.scroll(delta)
      return ""
    end
    return key
  end, { expr = true, desc = "Scroll tabs" })
end

return M
