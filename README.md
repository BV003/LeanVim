# nvim-config

My personal Neovim configuration.

## 工作方式：两个终端分离

编辑和 AI agent 分开放在两个终端窗口里，不互相嵌套：

```
┌─ 终端窗口 1 ─────────────┐ ┌─ 终端窗口 2 ──────────────┐
│ nvim                     │ │ herdr                     │
│ （文件树 + 编辑）        │ │ （只跑 code agents）      │
└──────────────────────────┘ └───────────────────────────┘
```

- **窗口 1：nvim**，负责看代码和编辑
- **窗口 2：herdr**，只用来运行 code agents，不在里面开 nvim
