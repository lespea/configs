function runx
    killall gpg-agent
    set -e SSH_AUTH_SOCK
    exec /usr/bin/Hyprland
end
