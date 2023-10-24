pyenv init - | source

fish_add_path ~/.cargo/bin

if status is-interactive
    keychain -q --agents gpg,ssh --eval id_ed25519 | source
end

