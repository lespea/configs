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
        source $_flag_loc/bin/activate.fish
        return
    end

    echo "Creating venv at $_flag_loc"
    uv venv --no-project --python (mise which python) $_flag_loc
    source $_flag_loc/bin/activate.fish

    echo "Installing packages"
    pipbase
    if set -q argv; and set -q argv[1]
        pipu $argv
    end

    if set -q deact
        echo "Deactivating"
        deactivate
    end

    echo "Done"
end
