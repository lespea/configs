function setupv
    mkvenv -l $nvim_python_loc -r -d colorama pynvim python-lsp-server[all] flake8 prettier pyright ruff ruff-lsp black yapf
end
