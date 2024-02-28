function setupv
    set -l pyver 3.12.2
    set -l pyname nvim3

    pyenv virtualenv --clear --force $pyver $pyname
    pyenv shell $pyname
    pipbase
    pipu colorama neovim python-lsp-server[all] flake8 prettier pyright ruff ruff-lsp
    pyenv shell normal
end
