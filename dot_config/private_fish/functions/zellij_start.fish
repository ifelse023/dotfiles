function zellij_start
    if not status --is-interactive; or set -q ZELLIJ; or set -q SSH_TTY; or test "$ZELLIJ_START" = 0
        return
    end

    set -l sessions (zellij list-sessions --short 2>/dev/null)

    switch (count $sessions)
        case 0
            zellij
        case 1
            zellij attach $sessions[1]
        case '*'
            set -l choice (
                begin
                    printf '%s\n' $sessions
                    printf '[NEW]\n[QUIT]\n'
                end | fzf --prompt='zellij session> ' --height=40% --no-multi
            )

            switch $choice
                case '[QUIT]' ''
                    return
                case '[NEW]'
                    read -lP 'New session name: ' session_name
                    test -z "$session_name"; and zellij; or zellij attach --create $session_name
                case '*'
                    zellij attach --create $choice
            end
    end
end

function z_kill_all
    zellij kill-all-sessions -y
    zellij delete-all-sessions -y
end

function za
    set -l sessions (zellij list-sessions 2>/dev/null | string replace -r ' .*' '')

    set -l count (count $sessions)

    if test $count -eq 0
        zellij -s dev
        return
    end

    if test $count -eq 1
        zellij attach $sessions[1]
        return
    end

    set -l session (printf '%s\n' $sessions | fzf 2>/dev/null)
    if test -n "$session"
        zellij attach "$session"
    end
end
