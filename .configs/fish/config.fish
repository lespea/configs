pyenv init - | source

fish_add_path ~/.cargo/bin

if status is-interactive
    starship init fish | source
end

