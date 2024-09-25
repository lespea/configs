function gvenv
    argparse 'f/force=?' -- $argv

    set -l f ''
    if set -q _flag_force
        set f '-r'
    end

    mkvenv -l "$HOME/.cache/global_venv" $f $PIP_NORM_PKGS
end
