if status is-interactive
    set fish_greeting ""
    starship init fish | source
    zoxide init fish --cmd cd | source
    source ~/.config/fish/atuin.fish
end
fish_add_path /home/wasd/architect/scripts

abbr -a c chezmoi
abbr -a n helix
abbr -a x helix
abbr -a j just
abbr -a py python
abbr -a wl wl-copy

abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'

source ~/.local/share/cargo/env.fish
