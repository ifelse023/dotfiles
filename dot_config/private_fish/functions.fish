# @fish-lsp-disable 4004
function update --description 'Update Arch Linux system packages (pacman and paru)'
    command sudo pacman -Syu && command paru -Syu
end

function diff --wraps diff --description 'Alias for diff --color=auto'
    command diff --color=auto $argv
end

function ls --wraps eza --description 'List files with eza (common options)'
    command eza -h --git --icons --color=auto --group-directories-first -s extension $argv
end

function la --wraps eza --description 'List all files with eza (including hidden)'
    command eza -a --git --icons --color=auto --group-directories-first $argv
end

function ll --wraps eza --description 'List files with eza (long format)'
    command eza -l --git --icons --color=auto --group-directories-first $argv
end

function lt --wraps eza --description 'List files with eza (tree view, level 2)'
    command eza -T --git --icons --color=auto --level=2 --group-directories-first $argv
end

function l. --wraps eza --description 'List only dotfiles in the current directory'
    # Arguments are passed to eza before being piped to ripgrep (rg).
    command eza -a $argv | command rg '^\.'
end

function cat --wraps bat --description 'Alias for bat --paging=never'
    command bat --paging=never $argv
end

function readelf --wraps llvm-readelf --description 'Alias for llvm-readelf'
    command llvm-readelf $argv
end

function objdump --wraps llvm-objdump --description 'Alias for llvm-objdump'
    command llvm-objdump $argv
end

function nm --wraps llvm-nm --description 'Alias for llvm-nm'
    command llvm-nm $argv
end

function xx
    set file (fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers {}')
    if test -n "$file"
        uwsm app -- neovide "$file"
    end
end

function cf
    set dir (fd --type d --exclude .git | fzf --height 20 --preview 'eza --tree --level=1 --color=always {}')
    if test -n "$dir"
        cd "$dir"
    end
end

function exit_if_empty
    if test -z (commandline)
        exit
    end
end

function mkdir-cd --argument dir
    mkdir -p -- $dir
    and cd -- $dir
end

function restore -a file
    set original (string replace -r '\.bak$' '' -- "$file")
    mv -n -- "$file" "$original"
end

function backup -a filename
    mv -n -- "$filename" "$filename.bak"
end

function cpr
    rsync -aHAX --info=NAME,PROGRESS2 --human-readable --no-inc-recursive -- $argv
end

function xc
    chezmoi edit --verbose --apply
end
