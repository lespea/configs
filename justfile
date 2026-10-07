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

# Cache the fish init scripts and completions so shell startup doesn't regenerate them; rerun after upgrading a tool
fish-cache: _fish-clean _fish-generate

# Delete previously generated files so tools removed from the list below don't leave stale ones behind
# (rg, not fd: fd matches names and the completions have to keep their `<tool>.fish` names; --no-ignore since both dirs are gitignored)
[private]
@_fish-clean:
    { rg --files-with-matches --null --no-ignore --fixed-strings {{ quote(fish_cache_marker) }} {{ quote(fish_dir / "conf.d") }} {{ quote(fish_dir / "completions") }} || true; } | xargs -0 rm -fv

# (fnox's hook-env reads FNOX_SHELL_OUTPUT at runtime, so it is patched into the cached script instead of set globally)
[parallel, private]
_fish-generate: \
    (_init "10" "mise" "mise activate fish") \
    (_init "20" "fnox" "fnox activate fish | sd '([^ (]*fnox) hook-env' 'FNOX_SHELL_OUTPUT=none $1 hook-env' | sd '(?m)^__fnox_env_eval$' ''") \
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
git *args:
    python3 setup_git.py {{ args }}

# Manage cargo-installed tools through pueue: install [-m|-p PKG|-f], missing, list
cargo *args:
    python3 cpkgs.py {{ args }}

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
