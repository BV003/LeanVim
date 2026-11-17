-- 在鼠标旁弹出的上下文菜单。
-- 用以 "]" 开头的隐藏菜单 + `:popup!`（鼠标位置），不改全局 PopUp 菜单。
--   require("config.popup").show("Name", { { "Label", function() ... end }, ... })
local M = {}

local actions = {} -- 菜单名 → 当前各项的回调

function M.run(name, i)
  local fn = actions[name] and actions[name][i]
  if fn then
    fn()
  end
end

function M.show(name, items)
  local menu = "]" .. name
  actions[name] = {}
  vim.cmd("silent! aunmenu " .. menu)
  for i, item in ipairs(items) do
    actions[name][i] = item[2]
    local label = item[1]:gsub("[ .\\]", "\\%0")
    vim.cmd(("anoremenu %s.%s <Cmd>lua require('config.popup').run(%q, %d)<CR>"):format(menu, label, name, i))
  end
  vim.cmd.popup({ menu, bang = true })
end

return M
