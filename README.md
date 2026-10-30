# nvim-config

My personal Neovim configuration.

## Workflow: two separate terminals

Editing and AI agents live in two separate terminal windows, not nested in each other.

- **Window 1: nvim**, for reading and editing code
- **Window 2: herdr**, for running code agents and experiment commands; nvim is not opened there

## Experiment commands go in herdr

Terminal commands such as experiments, training and evaluation all run in herdr, not in nvim's `:terminal`. nvim is only for editing; in herdr, long tasks keep running, logs are easy to check, and agents can read the results directly.

Only very short commands closely tied to the current edit (such as formatting the current file) may run inside nvim.

## Basic Vim operations

Before pressing keys, make sure you are in normal mode (press `Esc`) and the input method is set to English.

| Key | Action |
|---|---|
| `i` / `o` | Insert before cursor / open a new line below and insert |
| `Esc` | Return to normal mode |
| `:w` / `:q` / `:q!` | Save / quit / quit without saving |
| `h j k l` | Left, down, up, right |
| `w` / `b` | Next / previous word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Start / end of file |
| `/text` then `n` | Search, jump to next match |
| `x` | Delete a character |
| `dd` / `yy` / `p` | Delete a line / copy a line / paste |
| `ciw` | Change the word under the cursor |
| `u` / `Ctrl+r` | Undo / redo |
| `.` | Repeat the last change |
| `v` | Enter visual mode, then `d` to delete or `y` to copy |

### Learning order

**Tier 1**

- `i` / `Esc`: enter and leave insert mode
- `:w` / `:q` / `:wq` / `:q!`: save, quit, save and quit, quit without saving
- `u` / `Ctrl+r`: undo, redo
- `dd` / `yy` / `p`: delete line, copy line, paste

**Tier 2**

- `ciw`, `ci"`, `ci(`: change word, inside quotes, inside parentheses
- `.`: repeat the last change
- `/` / `n`: search, next match
- `o` / `O`: open a new line below/above and insert
- `A` / `I`: jump to end/start of line and insert

**Tier 3**

- `gg` / `G`: jump to start/end of file
- `:%s/old/new/g`: replace throughout the file

### Cursor jumps

Between lines:

| Key | Action |
|---|---|
| `5j` / `5k` | Jump 5 lines down / up |
| `:42` | Jump to line 42 |
| `gg` / `G` | Start / end of file |
| `Ctrl+d` / `Ctrl+u` | Half a page down / up |
| `{` / `}` | Previous / next blank line |

Within a line:

| Key | Action |
|---|---|
| `0` / `^` / `$` | Start of line / first non-blank character / end of line |
| `w` / `b` / `e` | Next word / previous word / end of word |
| `f<char>` / `F<char>` | Jump forward / backward to that character |
| `t<char>` | Jump to just before that character |
| `;` / `,` | Repeat the last `f`/`t`, forward / backward |
| `a` | Insert after cursor |
| `r<char>` | Replace a character |

## Keymaps

The leader key is Space.

### Search (fzf-lua)

| Key | Action |
|---|---|
| `Space Space` / `Space f f` | Search file names |
| `Space /` / `Space f g` | Search file contents |
| `Space f b` | Open files |
| `Space f r` | Recent files |
| `Space f w` | Search word under cursor |
| `Space f R` | Resume last search |
| `Space p` | Switch project (nvim config, plus projects in this machine's `lua/config/local.lua`; that file is not in git, so create it yourself on a new machine) |

### File tree (neo-tree)

| Key | Action |
|---|---|
| `Space e` | Toggle the file tree |

### Editing and windows

| Key | Action |
|---|---|
| `Space w` / `Ctrl+s` | Save |
| `Space q` | Close window |
| `Space \|` / `Space -` | Split left/right / split top/bottom |
| `Ctrl+h/j/k/l` | Move between windows |
| `Esc` | Clear search highlight |
| `j` / `k`, `↓` / `↑` | Move by screen line on wrapped lines (`5j` still moves by real line) |
| Visual mode `<` / `>` | Indent and keep the selection |
| Visual mode `J` / `K` | Move selected lines down / up |
| Terminal mode `Esc Esc` | Exit terminal mode |
