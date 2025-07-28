if status is-interactive
    set -U fish_greeting ""
    starship init fish | source
    zoxide init fish --cmd cd | source
    source ~/.config/fish/atuin.fish
end
fish_add_path /home/wasd/architect/scripts

abbr -a c chezmoi
abbr -a n vim
abbr -a j just
abbr -a py python

abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'

alias cat="bat --paging=never"
alias diff="diff --color=auto"
alias update='sudo pacman -Syu && paru -Syu'
alias vim='neovide'
alias ls='eza -h --git --icons --color=auto --group-directories-first -s extension'
alias la='eza -a --git --icons --color=auto --group-directories-first'
alias ll='eza -l --git --icons --color=auto --group-directories-first'
alias lt='eza -T --git --icons --color=auto --level=2 --group-directories-first'
alias l.="eza -a | rg '^\.'"

alias readelf='llvm-readelf'
alias objdump='llvm-objdump'
alias nm='llvm-nm'

function x
    uwsm app neovide
end

function xx
    set file (fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers {}')
    if test -n "$file"
        uwsm app -- neovide "$file"
    end
end

function xd
    set dir (fd --type d --exclude .git | fzf --height 20 --preview 'eza --tree --level=1 --color=always {}')
    if test -n "$dir"
        cd "$dir"
    end
end

function xc
    set file (fd --type f --hidden --exclude .git . ~/.local/share/chezmoi | fzf --preview 'bat --color=always --style=numbers {}')
    if test -n "$file"
        neovide "$file"
    end
end

function se
    sudoedit $argv
end

function exit_if_empty
    if test -z (commandline)
        exit
    end
end

source ~/.config/fish/env.fish
source ~/.local/share/cargo/env.fish
