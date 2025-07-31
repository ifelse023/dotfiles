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
        uwsm app -- hx "$file"
    end
end

function xd
    set dir (fd --type d --exclude .git | fzf --height 20 --preview 'eza --tree --level=1 --color=always {}')
    if test -n "$dir"
        cd "$dir"
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

function clean-unzip --argument zipfile
    if not test (echo $zipfile | string sub --start=-4) = .zip
        echo (status function): argument must be a zipfile
        return 1
    end

    if is-clean-zip $zipfile
        unzip $zipfile
    else
        set folder_name (echo $zipfile | trim-right '.zip')
        set target (basename $folder_name)
        mkdir $target || return 1
        unzip $zipfile -d $target
    end
end
function is-clean-zip --argument zipfile
    if string-empty $zipfile
        echo 'is-clean-zip: missing filename' >&2
        return 1
    end

    set summary (zip -sf $zipfile | string split0)
    set first_file (echo $summary | row 2 | string trim)
    set first_file_last_char (echo $first_file | string sub --start=-1)
    set n_files (echo $summary | awk NF | tail -1 | coln 2)
    test $n_files = 1 && test $first_file_last_char = /
end
function mkdir-cd --argument dir
    mkdir -p -- $dir
    and cd -- $dir
end

function restore --argument-names file
    set original (string replace '.bak' '' -- "$file")
    mv -- "$file" "$original"
end

function backup --argument-names filename
    cp -- "$filename" "$filename.bak"
end

function cpr
    rsync -aHAX --info=NAME,PROGRESS2 --human-readable --no-inc-recursive -- $argv
end

function xc
    chezmoi edit --verbose --apply
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

function sub
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

    fd --type f --hidden --exclude .git --exclude node_modules \
        --exclude target --exclude .cache -0 . $path \
        | sad -0 --unified=0 $pattern $replacement
end
