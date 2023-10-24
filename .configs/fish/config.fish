pyenv init - | source

fish_add_path ~/.cargo/bin

if status is-interactive
end

if not string length --quiet $SSH_AUTH_SOCK
    gpg-connect-agent updatestartuptty /bye &>/dev/null
    set -gx SSH_AUTH_SOCK "$(gpgconf --list-dirs agent-ssh-socket)"
end

