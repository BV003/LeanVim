-- 模糊搜索：fzf-lua（类似 VSCode 的 Ctrl+P 和全局搜索）
-- 仓库：https://github.com/ibhagwan/fzf-lua
-- 依赖命令行工具：fzf（必需）、fd（搜文件名）、rg（搜文件内容）
vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
})

require("fzf-lua").setup({
  -- 当前没有安装 Nerd Font，不显示文件图标
  defaults = {
    file_icons = false,
    git_icons = false,
  },
})

local fzf = require("fzf-lua")
local map = vim.keymap.set

-- 搜文件名（类似 Ctrl+P），默认忽略 .gitignore 中的文件
map("n", "<leader><leader>", fzf.files, { desc = "搜索文件" })
map("n", "<leader>ff", fzf.files, { desc = "搜索文件" })

-- 搜所有文件的内容（类似 Ctrl+Shift+F），边输入边搜索
map("n", "<leader>/", fzf.live_grep, { desc = "搜索内容" })
map("n", "<leader>fg", fzf.live_grep, { desc = "搜索内容" })

-- 搜已经打开的文件
map("n", "<leader>fb", fzf.buffers, { desc = "已打开的文件" })

-- 最近打开过的文件
map("n", "<leader>fr", fzf.oldfiles, { desc = "最近打开的文件" })

-- 搜当前光标下的单词
map("n", "<leader>fw", fzf.grep_cword, { desc = "搜索光标下的单词" })

-- 继续上一次的搜索
map("n", "<leader>fR", fzf.resume, { desc = "继续上一次搜索" })

-- 切换项目：列出 nvim 配置目录，以及本机 lua/config/local.lua 里配置的项目
-- local.lua 只放这台电脑独有的路径，已加入 .gitignore，不存在时只显示 nvim 配置目录
-- 选中后切换工作目录（之后的搜索、文件树都以它为准），并弹出文件搜索
map("n", "<leader>p", function()
  local ok, local_config = pcall(require, "config.local")
  if not ok then
    local_config = {}
  end

  local projects = {}
  -- project_roots 里每个目录下的子目录都算一个项目
  for _, root in ipairs(local_config.project_roots or {}) do
    for _, dir in ipairs(vim.fn.globpath(root, "*/", false, true)) do
      table.insert(projects, vim.fn.fnamemodify(dir:gsub("/$", ""), ":~"))
    end
  end
  table.insert(projects, "~/.config/nvim")
  -- projects 里是单独添加的项目
  for _, dir in ipairs(local_config.projects or {}) do
    table.insert(projects, dir)
  end

  fzf.fzf_exec(projects, {
    prompt = "项目> ",
    actions = {
      ["enter"] = function(selected)
        vim.cmd.cd(selected[1])
        fzf.files()
      end,
    },
  })
end, { desc = "切换项目" })
