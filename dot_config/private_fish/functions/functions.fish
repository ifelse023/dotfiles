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
