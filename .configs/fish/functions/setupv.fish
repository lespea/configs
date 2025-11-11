function setupv
    if not set -q nvim_venvs
        echo "nvim_venvs not set"
        return
    end

    mkdir -p "$nvim_venvs"

    if not test -f "$nvim_venvs/pyproject.toml"
        uv init --directory $nvim_venvs --name nvim --vcs none --no-readme --no-package --no-workspace
        rm -rf "$nvim_venvs/main.py"
    end

    set -l packages colorama pynvim python-lsp-server[all] flake8 prettier pyright ruff ruff-lsp black yapf

    uv add --directory $nvim_venvs -U --resolution highest --reinstall --refresh --compile-bytecode $packages

    pnpm install -C $nvim_venvs neovim
    pnpm update -C $nvim_venvs -L
    pnpm self-update -C $nvim_venvs
end
