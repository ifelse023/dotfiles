if status is-interactive
    set -U fish_greeting ""
    starship init fish | source
    zoxide init fish | source
    direnv hook fish | source
    zellij_start

end
set fish_cursor_insert line
set fish_cursor_external line
fish_add_path /home/wasd/architect/scripts

set -gx GOPATH "$HOME/.go"
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx GTK2_RC_FILES $XDG_CONFIG_HOME/gtk-2.0/gtkrc

set -gx PICO_SDK_PATH ~/.local/share/pico-sdk
set -gx CC clang
set -gx CXX "clang++"

set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/config"
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx PAGER "bat --paging=always --style=plain"
set -gx BAT_PAGER ""
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx GIT_PAGER "delta -s"

set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"
set -gx FZF_DEFAULT_OPTS "
--highlight-line 
--info=inline-right 
--ansi 
--layout=reverse 
--border=none
--preview 'bat --color=always --style=numbers --line-range=:500 {}'
--color=bg+:#283457,bg:#16161e,border:#27a1b9,fg:#c0caf5,gutter:#16161e,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#27a1b9,separator:#ff9e64,spinner:#ff007c
"

abbr -a c chezmoi
abbr -a n nvim
abbr -a j just
abbr -a py python

abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'

alias cat="bat --paging=never"
alias diff="diff --color=auto"
alias update='sudo pacman -Syu && paru -Syu'
alias x='nvim'

alias ls='eza -h --git --icons --color=auto --group-directories-first -s extension'
alias la='eza -a --git --icons --color=auto --group-directories-first'
alias ll='eza -l --git --icons --color=auto --group-directories-first'
alias lt='eza -T --git --icons --color=auto --level=2 --group-directories-first'
alias l.="eza -a | rg '^\.'"

function xx
    set file (fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers {}')
    if test -n "$file"
        uwsm app -- nvim "$file"
    end
end

function fcd
    set dir (fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=1 --color=always {}')
    if test -n "$dir"
        cd "$dir"
    end
end

function se
    sudoedit $argv
end

bind \ck zellij_start
