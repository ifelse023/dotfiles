if status is-interactive
    set -U fish_greeting ""
    starship init fish | source
    zoxide init fish | source
    direnv hook fish | source
end

fish_add_path /home/wasd/architect/scripts
fish_add_path ~/.cargo/bin

set -gx GOPATH "$HOME/.go"
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
set -gx GTK2_RC_FILES $XDG_CONFIG_HOME/gtk-2.0/gtkrc

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

abbr -a g git
abbr -a gc 'git commit'
abbr -a ga 'git add'
abbr -a gs 'git status'
abbr -a gl 'git log --oneline --graph'
abbr -a gd 'git diff'
abbr -a gp 'git push'

abbr -a c clear
abbr -a m make
abbr -a mc 'make clean'
abbr -a mt 'make test'

abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'

alias cat="bat --paging=never"
alias diff="diff --color=auto"
alias update='sudo pacman -Syu && paru -Syu'
alias py="python"

alias ls='eza -h --git --icons --color=auto --group-directories-first -s extension'
alias la='eza -a --git --icons --color=auto --group-directories-first'
alias ll='eza -l --git --icons --color=auto --group-directories-first'
alias lt='eza -T --git --icons --color=auto --level=2 --group-directories-first'
alias l.="eza -a | rg '^\.'"

function xx
    set file (fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers {}')
    if test -n "$file"
        uwsm app -- neovide "$file"
    end
end

function fcd
    set dir (fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=1 --color=always {}')
    if test -n "$dir"
        cd "$dir"
    end
end

function vim
    uwsm app -- neovide $argv
end

function x
    uwsm app -- nvim $argv
end

function se
    sudoedit $argv
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function sr
    if test (count $argv) -lt 2
        echo "Usage: sr <pattern> <replacement> [path]"
        return 1
    end

    set pattern $argv[1]
    set replacement $argv[2]
    set path "."

    if test (count $argv) -ge 3
        set path $argv[3]
    end

    fd --type f --hidden --exclude .git --exclude node_modules --exclude target --exclude .cache -0 . $path | sad -0 $pattern $replacement
end

function src
    if test (count $argv) -lt 3
        echo "Usage: src <extension> <pattern> <replacement> [path]"
        return 1
    end

    set ext $argv[1]
    set pattern $argv[2]
    set replacement $argv[3]
    set path "."

    if test (count $argv) -ge 4
        set path $argv[4]
    end

    fd --type f --extension $ext --hidden --exclude .git --exclude target --exclude build -0 . $path | sad -0 $pattern $replacement
end

bind \co xx
bind \cf fcd
