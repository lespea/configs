pyenv init - fish | source

fish_add_path ~/.cargo/bin

function final
    if set -q IS_ARCH; and not set -q DISPLAY; and string match $XDG_VTNR 1; and \
        systemctl -q is-active graphical.target
        exec /usr/bin/Hyprland
    else
        if not string length --quiet $SSH_AUTH_SOCK
            gpg-connect-agent updatestartuptty /bye &>/dev/null
            set -gx SSH_AUTH_SOCK "$(gpgconf --list-dirs agent-ssh-socket)"
        end
    end
end

if status is-interactive
    set -gx JAVA_OPTS '-server -XX:+UseG1GC -Xms1G -Xmx4G'
    set -gx SBT_OPTS  '-server -XX:+UseG1GC -Xms1G -Xmx4G'

    set -gx BAT_THME 'OneHalfDark'

    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

    if set -q IS_ARCH
    else
        set -gx LC_ALL en_US.UTF-8
    end

    atuin init fish --disable-up-arrow | source
    zoxide init fish | source

    final
end
