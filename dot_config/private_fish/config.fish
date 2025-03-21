# ===== INTERACTIVE SESSION SETTINGS =====
if status is-interactive
    # Disable fish greeting
    set fish_greeting
    starship init fish | source
    zoxide init fish | source
    direnv hook fish | source
end

# ===== PATH CONFIGURATION =====
fish_add_path /home/wasd/architect/scripts
fish_add_path ~/.cargo/bin
# fish_add_path ~/.nix-profile/bin
# ===== ENVIRONMENT VARIABLES =====
set -gx GOPATH "/home/wasd/.go"
# set -gx PICO_SDK_PATH "/home/wasd/.pico-sdk/sdk/2.1.1"

# Tool configurations
set -gx RIPGREP_CONFIG_PATH "/home/wasd/.config/ripgrep/config"

# Pager settings
set -gx MOAR --no-linenumbers
set -gx PAGER /usr/bin/moar
set -gx BAT_PAGER "moar --no-linenumbers"
# FZF settings
set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden"
set -gx FZF_DEFAULT_OPTS "
--highlight-line 
--info=inline-right 
--ansi 
--layout=reverse 
--border=none
--color=bg+:#283457,bg:#16161e,border:#27a1b9,fg:#c0caf5,gutter:#16161e,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#27a1b9,separator:#ff9e64,spinner:#ff007c
"

# ===== FILE OPERATION ALIASES =====
alias open-task="uwsm app -- firefox-beta --new-tab (open aufgabe.txt)"
alias xx="fzf --bind 'enter:become(helix {})'"
alias cat="bat"
alias diff="diff --color=auto"
alias fcd 'cd $(fd -type d | fzf)'

alias update='sudo pacman -Syu && paru -Syu'

# Replace ls with eza
alias ls='eza -h --git --icons --color=auto --group-directories-first -s extension' # preferred listing
alias la='eza -ah --git --icons --color=auto --group-directories-first -s extension' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles
alias py python

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

function vim
    uwsm app -- helix $argv
end

function h
    uwsm app -- helix $argv
end

function hx
    uwsm app -- helix $argv
end

function hc
    chezmoi edit --apply
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
