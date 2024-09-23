function setupv
    if not set -q nvim_python_loc
        echo "python loc var not set! `$nvim_python_loc`"
        return
    end

    if test -d $nvim_python_loc
        echo "Cleaning $nvim_python_loc"
        rm -rf $nvim_python_loc
    end


    echo "Creating venv at $nvim_python_loc"
    uv venv --no-project $nvim_python_loc
    source $nvim_python_loc/bin/activate.fish

    echo "Installing packages"
    pipbase
    pipu colorama pynvim python-lsp-server[all] flake8 prettier pyright ruff ruff-lsp black yapf

    echo "Done"
    deactivate
end
