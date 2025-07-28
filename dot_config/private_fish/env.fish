set -gx GOPATH $XDG_DATA_HOME/go
set -gx CARGO_HOME $XDG_DATA_HOME/cargo

set -gx GTK2_RC_FILES $XDG_CONFIG_HOME/gtk-2.0/gtkrc
set -gx PICO_SDK_PATH "$HOME/dev/lib/sdk"

set -gx CC clang
set -gx CXX "clang++"

set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/config"
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx PAGER "bat --paging=always --style=plain"
set -gx BAT_PAGER ""
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx GIT_PAGER "delta -s"

set -gx FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS \
      --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"
