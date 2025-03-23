function setEnvs
    set -gax JAVA_OPTS '-Xmx16G -XX:MaxInlineLevel=21'
    set -gax SBT_OPTS '-Xss1M -XX:ReservedCodeCacheSize=512m -XX:+UseParallelGC'

    set -gx BAT_THME 'OneHalfDark'

    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

    set -gu PIP_NORM_PKGS colorama ipython pandas numpy httpie requests pyyaml exrex beautifulsoup4 lxml html5lib bs4

    if set -q XDG_CACHE_DIR
        set -gx nvim_python_loc "$XDG_CACHE_HOME/nvim_python"
    else
        set -gx nvim_python_loc "$HOME/.cache/nvim_python"
    end

    set -gx CMAKE_GENERATOR Ninja

    if set -q IS_ARCH
        set -gx USE_CODEIUM 1
    else
        set -gx LC_ALL en_US.UTF-8
    end

    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT "-c"

    set -gx TAPLO_CONFIG "$XDG_CONFIG_HOME/taplo/taplo.toml"
end

function setAbbs
    # search
    abbr --add G  -p anywhere '| rg'
    abbr --add GA -p anywhere '| rg -M0'

    # bat
    abbr --add L  -p anywhere '| bat'
    abbr --add LP -p anywhere '| bat -p'
    abbr --add BL -p anywhere '| bat -pP -llog'

    # fmt
    abbr --add BJ -p anywhere '| jq | bat -ljson'
    abbr --add BL -p anywhere '| bat -pP -llog'
    abbr --add BHL -p anywhere '| bunx prettier --parser html | bat -lhtml'

    # fmt cursor
    abbr --add BH --set-cursor 'bunx prettier % | bat -lhtml'
    abbr --add TL --set-cursor 'tail -F % | bat -pP -llog'

    # counts
    abbr --add UC -p anywhere '| sort | uniq -c | sort -rh'
    abbr --add LC -p anywhere '| wc -l'
    abbr --add WC -p anywhere '| wc -l'

    # misc
    abbr --add g. -p anywhere './...'
end

function runSources
    if type -q mise
        mise activate fish | source
        mise completion fish | source
    end

    act atuin init fish --disable-up-arrow
    act zoxide init fish
    act just --completions fish
    act rg --generate complete-fish

    act direnv hook fish

    bind . 'expand-dot-to-parent-directory-path'
end

function act
    set -l cmd $argv[1]

    if type -q $cmd
        $cmd $argv[2..-1] | source
    end
end

function hypr
    if set -q IS_ARCH; and type -q uwsm; and uwsm check may-start
        exec uwsm start hyprland.desktop
    end
end

function final
    set -l custom "$HOME/.fish_custom"
    if test -e $custom
        source $custom
    end

    gvenv
end

function setupFish
    for mode in (bind --list-modes)
        bind -M $mode ctrl-c cancel-commandline
    end
end

if status is-interactive
    if set -q IS_MAC; and set -q brewpath
        $brewpath shellenv fish | source
    end

    setupFish
    setEnvs
    setAbbs

    hypr

    runSources

    final
end

