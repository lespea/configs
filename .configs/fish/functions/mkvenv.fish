function mkvenv
    argparse 'l/loc=!string match -rq \'^\S{5,}\' "$_flag_value"' 'r/reinstall=?' 'd/deact=?' -- $argv
    or return

    if not set -q _flag_loc
        echo "python _flag_loc var not set!"
        return
    end

    if set -q _flag_reinstall
        if test -d $_flag_loc
            echo "Cleaning $_flag_loc"
            rm -rf $_flag_loc
        end
    else if test -d $_flag_loc
        if not set -q _flag_deact
            source "$_flag_loc/bin/activate.fish"
        end
        return
    end

    set cmds uv venv --no-project --python (mise which python) $_flag_loc
    echo "Create venv; $cmds"
    $cmds

    echo "Activating $_flag_loc"
    source "$_flag_loc/bin/activate.fish"

    echo "Installing packages"
    pipbase
    pipu $argv # pipu checks for empty lists

    if set -q _flag_deact
        echo "Deactivating $_flag_loc"
        deactivate
    end
end
