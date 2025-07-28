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

function echo-variable --no-scope-shadowing
    if set -q -- $argv
        set varname $argv
    else
        set varname (echo $argv | string upper)
    end
    eval 'echo $'$varname
end
