if set -q IS_MAC; and set -q brewpath
        eval "$($brewpath shellenv)"
end

pyenv init - --no-rehash fish | source

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
    just --completions fish | source
    rg --generate complete-fish | source

    bind . 'expand-dot-to-parent-directory-path'

    final
end
