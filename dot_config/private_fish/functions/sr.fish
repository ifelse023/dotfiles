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
