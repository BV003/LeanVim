-- 编辑器选项（相当于 VSCode 的 settings.json）
-- 查看任意选项的说明：:help '选项名'，例如 :help 'number'
local opt = vim.opt

-- 行号
opt.number = true           -- 显示行号
opt.relativenumber = true   -- 相对行号，方便 5j、3k 这类跳转
opt.cursorline = true       -- 高亮当前行
opt.signcolumn = "yes"      -- 始终显示左侧标记栏（之后放 git/报错标记），避免文字左右跳动

-- 缩进：默认 4 个空格，具体语言之后可以单独覆盖
opt.expandtab = true        -- Tab 键插入空格
opt.tabstop = 4             -- 一个 Tab 显示为 4 列
opt.shiftwidth = 4          -- >> 和自动缩进的宽度
opt.smartindent = true      -- 换行时智能缩进

-- 搜索
opt.ignorecase = true       -- 搜索忽略大小写
opt.smartcase = true        -- 但搜索词含大写字母时区分大小写
opt.hlsearch = true         -- 高亮所有匹配
opt.incsearch = true        -- 边输入边跳转到匹配

-- 显示
opt.wrap = true             -- 长行自动折行显示（类似 VSCode 的自动换行，文件内容不变）
opt.linebreak = true        -- 在空格处折行，不把单词拆开
opt.breakindent = true      -- 折行部分保持原来的缩进
opt.scrolloff = 8           -- 光标上下至少保留 8 行
opt.sidescrolloff = 8
opt.termguicolors = true    -- 启用真彩色，主题需要
opt.list = true             -- 显示不可见字符
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- 系统剪贴板：y 复制、p 粘贴直接与 macOS 剪贴板互通（和 VSCode 一样）
opt.clipboard = "unnamedplus"

-- 鼠标：所有模式下都能用鼠标点击、选择、滚动
opt.mouse = "a"

-- 分屏：新窗口出现在右边和下边（更符合 VSCode 习惯）
opt.splitright = true
opt.splitbelow = true

-- 文件
opt.undofile = true         -- 持久化撤销历史，关掉文件再打开仍能 u 撤销
opt.swapfile = false        -- 不生成 .swp 交换文件
opt.confirm = true          -- 有未保存修改时退出，弹出确认而不是报错
opt.autoread = true         -- 文件被外部修改（如 AI agent）且本地没有未保存修改时，自动重新读取

-- 响应速度
opt.updatetime = 250        -- 停止输入 250ms 后触发事件（之后 LSP 悬浮提示会用到）
opt.timeoutlen = 400        -- 组合键（如 <leader>w）的等待时间
