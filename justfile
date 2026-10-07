# Helpers for this configs repo; run `just` to list them.

set shell := ["bash", "-euo", "pipefail", "-c"]

steam_nm_policy := justfile_directory() / ".configs/systemd/user/steam-fake-nm.conf"
steam_nm_policy_dst := "/etc/dbus-1/system.d/steam-fake-nm.conf"
fish_dir := justfile_directory() / ".configs/fish"
# Written into every generated file so `_fish-clean` can find them (and only them)
fish_cache_marker := "just-fish-cache-generated"

[private]
default:
    @just --list

# Symlink dotfiles and ~/.config dirs into this repo
links:
    ./setup_links.sh

# One-time fish setup: universal env vars, aliases (written to functions/), paths; rerun after editing setup.fish
fish-setup:
    fish {{ quote(fish_dir / "setup.fish") }}

# Remove leftovers from things we've retired (submodule, venvs, old functions/env vars, unused mise tools); safe to rerun
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    cd {{ quote(justfile_directory()) }}
    cleaned=0
    note() { echo "removed: $*"; cleaned=1; }

    # base16-shell submodule: index entry, .gitmodules, .git/config, and the cloned module dir
    if [[ $(git ls-files --stage -- base16) == 160000* ]]; then
        git rm -qf base16
        note "base16 submodule from the index"
    fi
    if [[ -f .gitmodules ]] && git config -f .gitmodules --get submodule.base16.path >/dev/null; then
        git config -f .gitmodules --remove-section submodule.base16
        if [[ -z $(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' || true) ]]; then
            git rm -qf --ignore-unmatch .gitmodules
            rm -f .gitmodules
            note ".gitmodules (no submodules left)"
        else
            git add .gitmodules
            note "base16 entry from .gitmodules"
        fi
    fi
    if git config --get submodule.base16.url >/dev/null; then
        git config --remove-section submodule.base16
        note "submodule.base16 from .git/config"
    fi
    module_dir=$(git rev-parse --git-path modules/base16)
    if [[ -d $module_dir ]]; then
        rm -rf "$module_dir"
        note "$module_dir"
    fi
    if [[ -e base16 ]] && ! git ls-files --error-unmatch base16 >/dev/null 2>&1; then
        rm -rf base16
        note "base16 working directory"
    fi

    # nvim python/node provider venv (the providers are disabled now)
    venv_dir="${XDG_CACHE_HOME:-$HOME/.cache}/nvim_venvs"
    if [[ -d $venv_dir ]]; then
        rm -rf "$venv_dir"
        note "$venv_dir"
    fi

    # fish functions we no longer define (generated or hand-written; they linger on machines that had them)
    for name in gcola normpkgs oplogs pdump setupv synpip synpipf synpipr whosts; do
        file={{ quote(fish_dir) }}/functions/$name.fish
        if [[ -e $file || -L $file ]]; then
            rm -f "$file"
            note "function $name"
        fi
    done

    # fish universal variables we no longer set (LC_ALL was replaced by LANG)
    if command -v fish >/dev/null; then
        for var in nvim_venvs LC_ALL; do
            if fish -c "set -qU $var"; then
                fish -c "set -Ue $var"
                note "universal variable \$$var"
            fi
        done
    fi

    # mise: versions and tools (black, isort, pypi:ruff, ...) no longer referenced by any tracked config
    if command -v mise >/dev/null; then
        mise prune
    fi

    if [[ $cleaned == 0 ]]; then echo "nothing else to clean"; fi

# Cache the fish init scripts and completions so shell startup doesn't regenerate them; rerun after upgrading a tool
fish-cache: _fish-clean _fish-generate

# Delete previously generated files so tools removed from the list below don't leave stale ones behind
# (rg, not fd: fd matches names and the completions have to keep their `<tool>.fish` names; --no-ignore since both dirs are gitignored)
[private]
@_fish-clean:
    { rg --files-with-matches --null --no-ignore --fixed-strings {{ quote(fish_cache_marker) }} {{ quote(fish_dir / "conf.d") }} {{ quote(fish_dir / "completions") }} || true; } | xargs -0 rm -fv

# mise: run as if from a shell without mise active, otherwise it emits a "deactivate" preamble that bakes in the current PATH
# fnox: its absolute (versioned) path becomes `command fnox` so upgrades don't break the cache; hook-env reads
# FNOX_SHELL_OUTPUT at runtime, so it is patched into the cached script instead of set globally
[parallel, private]
_fish-generate: \
    (_init "10" "mise" "env -u __MISE_DIFF -u __MISE_SESSION -u __MISE_ENV_CACHE_KEY PATH=\"${__MISE_ORIG_PATH:-$PATH}\" \"$(command -v mise)\" activate fish") \
    (_init "20" "fnox" "fnox activate fish | sd '(command )?/[^ ()]*/fnox ' 'command fnox ' | sd 'command fnox hook-env' 'FNOX_SHELL_OUTPUT=none command fnox hook-env' | sd '(?m)^__fnox_env_eval$' ''") \
    (_init "20" "atuin" "atuin init fish --disable-up-arrow") \
    (_init "20" "zoxide" "zoxide init fish") \
    (_completion "mise" "mise completion fish") \
    (_completion "fnox" "fnox completion fish") \
    (_completion "bat" "bat --completion fish") \
    (_completion "just" "just --completions fish") \
    (_completion "rg" "rg --generate complete-fish") \
    (_completion "ink" "ink completions fish") \
    (_completion "gh" "gh completion -s fish") \
    && _os-cache

# macOS only: brew's env has to land before the other init scripts, which expect brew-installed tools on PATH
[macos, private]
_os-cache: (_gen fish_dir / "conf.d/00-brew.fish" "/opt/homebrew/bin/brew" "interactive" "/opt/homebrew/bin/brew shellenv fish")

[linux, private]
_os-cache:

# `order` prefixes the file name since conf.d loads alphabetically (mise before the tools it installs)
[private]
_init order bin cmd: (_gen fish_dir / "conf.d" / order + "-" + bin + ".fish" bin "interactive" cmd)

[private]
_completion bin cmd: (_gen fish_dir / "completions" / bin + ".fish" bin "plain" cmd)

# Run `cmd` into `dest` via a temp file so a failing generator never leaves a truncated script; skips missing tools
[private]
_gen dest bin kind cmd:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v {{ bin }} >/dev/null || { echo "skip {{ bin }}: not installed"; exit 0; }
    mkdir -p {{ quote(parent_directory(dest)) }}
    tmp={{ quote(dest + ".tmp") }}
    trap 'rm -f "$tmp"' EXIT
    {
        if [[ {{ kind }} == interactive ]]; then echo 'status is-interactive; or return'; fi
        echo '# {{ fish_cache_marker }}: do not edit; regenerate with `just fish-cache`'
        {{ cmd }}
    } > "$tmp"
    mv "$tmp" {{ quote(dest) }}
    echo "wrote {{ dest }}"

# Apply global git settings (`just git --help` for options)
[positional-arguments]
git *args:
    uv run setup_git.py "$@"

# Manage cargo-installed tools through pueue: install [-m|-p PKG|-f], missing, list
[positional-arguments]
cargo *args:
    uv run cpkgs.py "$@"

# Install the system D-Bus policy that lets steam-fake-nm own the NetworkManager name
steam-nm-policy:
    #!/usr/bin/env bash
    set -euo pipefail
    # Copied, not symlinked: root's dbus daemon must not trust a file this user can edit.
    if [[ $(uname) != Linux ]]; then
        echo "only for the Linux desktop" >&2
        exit 1
    fi
    if pacman -Q networkmanager &>/dev/null; then
        echo "real NetworkManager is installed; not installing the fake-NM policy" >&2
        exit 1
    fi
    if cmp -s "{{ steam_nm_policy }}" "{{ steam_nm_policy_dst }}"; then
        echo "{{ steam_nm_policy_dst }} is already up to date"
        exit 0
    fi
    sudo install -m644 "{{ steam_nm_policy }}" "{{ steam_nm_policy_dst }}"
    sudo systemctl reload dbus.service
    echo "installed; if steam-fake-nm.service failed to claim the name, restart it:"
    echo "  systemctl --user restart steam-fake-nm.service"

# Lint and format-check the shell scripts and the Hyprland Lua config
lint:
    mise exec shellcheck -- shellcheck *.sh .configs/hypr/session.sh
    shfmt -ci -i 4 -d *.sh
    shfmt -ci -d .configs/hypr/session.sh
    stylua --check .configs/hypr
