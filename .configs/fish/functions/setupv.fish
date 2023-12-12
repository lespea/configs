function setupv
    set -l pyver 3.12.1
    set -l pyname nvim3

    pyenv virtualenv --clear --force $pyver $pyname
    pyenv shell $pyname
    pipbase
    pipu colorama neovim python-lsp-server[all]
    pyenv shell normal
end
