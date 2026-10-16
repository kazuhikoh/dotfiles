# dotfiles

## bootstrap

1. Requirements: `homebrew`, `mise`
1. Clone this repository into `dotfiles.root` (in `mise.toml`)
1. Run following:
  ```
  cd <dotfiles.root>
  mise trust
  mise bootstrap dotfiles apply  
  ```

## Terminal Keymaps

TMUX

| Key | Action |
| --- | ------ |
| `Ctrl-T` | PrefixKey |
| Prefix + `-` | Split Pane (Vertical) |
| Prefix + `|` | Split Pane (Horizontal) |
| Prefix + `Shift-[←→↑↓]` | Expand Pane |

NeoVim

| Key | Action |
| --- | ------ |
| LSP > Blink | |
| `Ctrl-[jk]` | Select suggestion(↓↑) |


