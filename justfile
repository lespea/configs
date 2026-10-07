# Helpers for this configs repo; run `just` to list them.

set shell := ["bash", "-euo", "pipefail", "-c"]

steam_nm_policy := justfile_directory() / ".configs/systemd/user/steam-fake-nm.conf"
steam_nm_policy_dst := "/etc/dbus-1/system.d/steam-fake-nm.conf"
fish_dir := justfile_directory() / ".configs/fish"

[private]
default:
    @just --list

# Symlink dotfiles and ~/.config dirs into this repo
links:
    ./setup_links.sh

# Cache the fish init scripts and completions so shell startup doesn't regenerate them; rerun after upgrading a tool
# (fnox's hook-env reads FNOX_SHELL_OUTPUT at runtime, so it is patched into the cached script instead of set globally)
[parallel]
fish-cache: \
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
@_gen dest bin kind cmd:
    if ! command -v {{ bin }} >/dev/null; then echo "skip {{ bin }}: not installed"; exit 0; fi
    mkdir -p "$(dirname "{{ dest }}")"
    if [[ {{ kind }} == interactive ]]; then echo 'status is-interactive; or return' > "{{ dest }}.tmp"; else : > "{{ dest }}.tmp"; fi
    {{ cmd }} >> "{{ dest }}.tmp" || { rm -f "{{ dest }}.tmp"; exit 1; }
    mv "{{ dest }}.tmp" "{{ dest }}"
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
