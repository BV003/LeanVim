# nvim-config

My personal Neovim configuration.

## 工作方式：两个终端分离

编辑和 AI agent 分开放在两个终端窗口里，**不互相嵌套**：

```
┌─ 终端窗口 1 ─────────────┐ ┌─ 终端窗口 2 ──────────────┐
│ nvim                     │ │ herdr                     │
│ （文件树 + 编辑）        │ │ （只跑 code agents：      │
│                          │ │   claude、codex 等）      │
└──────────────────────────┘ └───────────────────────────┘
```

| 窗口 | 负责 | 启动 |
|---|---|---|
| 1 | **nvim**：看代码、编辑、文件树 | `nvim .` |
| 2 | **herdr**：运行和管理 code agents，不在里面开 nvim | `herdr` |

### 为什么分离

- **没有按键冲突**：nvim 和 herdr 各自直接接收按键，不用为嵌套额外配置快捷键
- **显示稳定**：agent 的界面跑在真正的终端软件里，而不是 nvim 的内置终端
- **互不影响**：重启 nvim（例如改了配置）不会中断 agent；herdr 的会话在后台持续运行，关掉窗口后运行 `herdr` 即可回到原来的状态

### 配合要点

- agent 改了文件后，nvim 会自动重新读取（`options.lua` 中的 `autoread` 加 `autocmds.lua` 中的 `checktime`）。触发时机：切回 nvim 窗口、切换文件、停止操作约 0.25 秒后
- 如果 nvim 里有未保存的修改，不会被自动覆盖，会提示你选择保留哪个版本

## 目录结构

```
~/.config/nvim/
├── init.lua                 入口：设置 leader 键（空格），按顺序加载模块
├── nvim-pack-lock.json      插件版本锁定（vim.pack 自动生成，需提交）
└── lua/
    ├── config/
    │   ├── options.lua      编辑器选项
    │   ├── keymaps.lua      快捷键
    │   └── autocmds.lua     自动命令
    └── plugins/
        └── neo-tree.lua     文件树
```

插件由 nvim 0.12 自带的 `vim.pack` 管理，安装在 `~/.local/share/nvim/site/pack/core/opt/`，不在本仓库中。

## 新电脑上安装

```bash
brew install neovim ripgrep fd
git clone https://github.com/BV003/nvim-config ~/.config/nvim
nvim   # 首次启动时 vim.pack 会提示安装插件
```
