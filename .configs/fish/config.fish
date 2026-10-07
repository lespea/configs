# Env vars and other one-time settings live in setup.fish (`just fish-setup`)

function setAbbs
    # search
    abbr --add G -p anywhere '| rg'
    abbr --add GA -p anywhere '| rg -M0'

    # bat
    abbr --add L -p anywhere '| bat'
    abbr --add LP -p anywhere '| bat -p'
    abbr --add BL -p anywhere '| bat -pP -llog'

    # fmt
    abbr --add BJ -p anywhere '| gojq | bat -ljson'
    abbr --add BHL -p anywhere '| bunx prettier --parser html | bat -lhtml'

    # fmt cursor
    abbr --add BH --set-cursor 'bunx prettier % | bat -lhtml'
    abbr --add TL --set-cursor 'tail -F % | bat -pP -llog'

    # counts
    abbr --add UC -p anywhere '| sort | uniq -c | sort -rh'
    abbr --add LC -p anywhere '| wc -l'
    abbr --add WC -p anywhere '| wc -l'

    abbr --add NF -p anywhere '| numfmt --grouping --field=-'

    # misc
    abbr --add g. -p anywhere './...'
end

function hypr
    if set -q IS_ARCH; and type -q uwsm; and uwsm check may-start -q
        exec uwsm start hyprland.desktop
    end
end

function final
    set -l custom "$HOME/.fish_custom"
    if test -e $custom
        source $custom
    end
end

function setupBinds
    bind . expand-dot-to-parent-directory-path

    for mode in (bind --list-modes)
        bind -M $mode ctrl-c cancel-commandline
    end
end

if status is-interactive
    hypr

    setupBinds
    setAbbs

    final
end
