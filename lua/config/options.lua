-- Editor options (equivalent to VSCode's settings.json)
-- See the docs for any option: :help 'option-name', e.g. :help 'number'
local opt = vim.opt

-- Line numbers
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Relative line numbers, handy for jumps like 5j, 3k
opt.cursorline = true       -- Highlight the current line
opt.signcolumn = "yes"      -- Always show the sign column (for later git/error signs) so text doesn't shift sideways

-- Indentation: 4 spaces by default; specific languages can override this later
opt.expandtab = true        -- Tab key inserts spaces
opt.tabstop = 4             -- A tab displays as 4 columns
opt.shiftwidth = 4          -- Width of >> and auto-indent
opt.smartindent = true      -- Smart indent on new lines

-- Search
opt.ignorecase = true       -- Case-insensitive search
opt.smartcase = true        -- But case-sensitive when the query contains uppercase
opt.hlsearch = true         -- Highlight all matches
opt.incsearch = true        -- Jump to matches while typing

-- Display
opt.wrap = true             -- Soft-wrap long lines (like VSCode's word wrap; file content is unchanged)
opt.linebreak = true        -- Wrap at spaces rather than splitting words
opt.breakindent = true      -- Wrapped parts keep the original indentation
opt.scrolloff = 8           -- Keep at least 8 lines above and below the cursor
opt.sidescrolloff = 8
opt.termguicolors = true    -- Enable true color, required by the theme
opt.list = true             -- Show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }  -- Hide the ~ on empty lines past end of file
opt.showmode = false        -- Mode is already shown in the status line (lualine), don't repeat it in the command line

-- System clipboard: y and p share the macOS clipboard directly (same as VSCode)
opt.clipboard = "unnamedplus"

-- Mouse: click, select and scroll in all modes
opt.mouse = "a"

-- Splits: new windows open to the right and below (closer to VSCode)
opt.splitright = true
opt.splitbelow = true

-- Files
opt.undofile = true         -- Persist undo history, so u still works after closing and reopening a file
opt.swapfile = false        -- Don't create .swp swap files
opt.confirm = true          -- When quitting with unsaved changes, ask for confirmation instead of erroring
opt.autoread = true         -- Reload automatically when a file changes externally (e.g. an AI agent) and has no unsaved local changes

-- Responsiveness
opt.updatetime = 250        -- Fire events 250ms after typing stops (LSP hover will use this later)
opt.timeoutlen = 400        -- Wait time for key sequences (e.g. <leader>w)
