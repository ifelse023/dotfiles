function zellij_start
    if set -q ZELLIJ || set -q SSH_TTY
        return
    end

    set sessions (zellij list-sessions --short 2>/dev/null)

    if test (count $sessions) -eq 0
        zellij
    else if test (count $sessions) -eq 1
        echo "Attaching to existing session: $sessions[1]"
        zellij attach $sessions[1]
    else
        echo "Multiple zellij sessions found:"
        for i in (seq (count $sessions))
            echo "  $i) $sessions[$i]"
        end
        echo "  n) Create new session"
        echo "  q) Skip zellij and continue"

        read -P "Choose session (1-"(count $sessions)", n, q): " choice

        switch $choice
            case q Q
                return
            case n N
                read -P "Enter name for new session: " session_name
                if test -z "$session_name"
                    zellij
                else
                    zellij --session $session_name
                end
            case '*'
                # Validate numeric input
                if string match -qr '^\d+$' $choice
                    and test $choice -ge 1
                    and test $choice -le (count $sessions)
                    echo "Attaching to session: $sessions[$choice]"
                    zellij attach $sessions[$choice]
                else
                    echo "Invalid choice. Skipping zellij."
                    return
                end
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
