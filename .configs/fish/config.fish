if set -q IS_ARCH
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end

if set -q IS_MAC; and set -q brewpath
        eval "$($brewpath shellenv)"
end

function final
    set -l custom "$HOME/.fish_custom"
    if test -e "$custom"
        source $custom
    end

    if set -q IS_ARCH; and type -q uwsm; and uwsm check may-start
        exec uwsm start hyprland.desktop
    else
        gvenv
    end
end

if status is-interactive
    ## Abbreviations

    # set -l foreground f9fbff
    # set -l selection 3b3d4d
    # set -l comment 636572
    # set -l red fe4c4c
    # set -l orange fe854c
    # set -l yellow ffc965
    # set -l green 65ff91
    # set -l purple b58cd8
    # set -l sky 7fe7ff
    # set -l pink ff99e0
    #
    # # Syntax Highlighting Colors
    # set -g fish_color_normal $foreground
    # set -g fish_color_command $sky
    # set -g fish_color_keyword $pink
    # set -g fish_color_quote $yellow
    # set -g fish_color_redirection $foreground
    # set -g fish_color_end $orange
    # set -g fish_color_error $red
    # set -g fish_color_param $purple
    # set -g fish_color_comment $comment
    # set -g fish_color_selection --background=$selection
    # set -g fish_color_search_match --background=$selection
    # set -g fish_color_operator $green
    # set -g fish_color_escape $pink
    # set -g fish_color_autosuggestion $comment
    #
    # # Completion Pager Colors
    # set -g fish_pager_color_progress $comment
    # set -g fish_pager_color_prefix $sky
    # set -g fish_pager_color_completion $foreground
    # set -g fish_pager_color_description $comment
    # set -g fish_pager_color_selected_background --background=$selection

    abbr --add G  -p anywhere '| rg'
    abbr --add GA -p anywhere '| rg -M0'
    abbr --add L  -p anywhere '| bat'
    abbr --add LC -p anywhere '| wc -l'
    abbr --add LP -p anywhere '| bat -p'
    abbr --add BL -p anywhere '| bat -pP -llog'
    abbr --add BJ -p anywhere '| jq | bat -ljson'
    abbr --add UC -p anywhere '| sort | uniq -c | sort -rh'
    abbr --add WC -p anywhere '| wc -l'

    set -gx JAVA_OPTS '-server -XX:+UseG1GC -Xmx8G -XX:-TieredCompilation'
    set -gx SBT_OPTS '-server -XX:+UseG1GC -Xmx8G -Xss2M -XX:ReservedCodeCacheSize=512M'

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

    set -gx TAPLO_CONFIG "$XDG_CONFIG_HOME/taplo/taplo.toml"

    atuin init fish --disable-up-arrow | source
    zoxide init fish | source
    just --completions fish | source
    rg --generate complete-fish | source

    if type -q direnv
        direnv hook fish | source
    end

    if type -q mise
        mise activate fish | source
        mise completion fish | source
    end

    bind . 'expand-dot-to-parent-directory-path'

    final
end
