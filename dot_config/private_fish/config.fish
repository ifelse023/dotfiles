if status is-interactive
    set -gx ZELLIJ_AUTO_ATTACH true # one persistent session
    eval (zellij setup --generate-auto-start fish | string collect)

    set fish_greeting ""
    starship init fish | source
    zoxide init fish --cmd cd | source
    source ~/.config/fish/atuin.fish
end

fish_add_path /home/wasd/architect/scripts

abbr -a c chezmoi
abbr -a n hx
abbr -a x hx
abbr -a j just
abbr -a py python
abbr -a wl wl-copy
abbr -a rm 'rm -rf'
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'

source ~/.config/fish/functions.fish
