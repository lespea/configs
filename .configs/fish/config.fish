if set -q IS_MAC; and set -q brewpath
        eval "$($brewpath shellenv)"
end

pyenv init - fish | source

function final
    set -l custom "$HOME/.fish_custom"
    if test -e "$custom"
        source $custom
    end

    if set -q IS_ARCH; and not set -q DISPLAY; and string match -q $XDG_VTNR 1; and \
        systemctl -q is-active graphical.target
        exec /usr/bin/Hyprland
    else
        if not string match -q "S.gpg-agent" "$SSH_ATUH_SOCK"
            gpg-connect-agent updatestartuptty /bye &>/dev/null
            set -gx SSH_AUTH_SOCK "$(gpgconf --list-dirs agent-ssh-socket)"
        end
    end
end

if status is-interactive
    ## Abbreviations

    abbr --add G  -p anywhere '| rg'
    abbr --add GA -p anywhere '| rg -M0'
    abbr --add L  -p anywhere '| bat'
    abbr --add LC -p anywhere '| wc -l'
    abbr --add LP -p anywhere '| bat -p'
    abbr --add UC -p anywhere '| sort | uniq -c | sort -rh'
    abbr --add WC -p anywhere '| wc -l'

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
