# Helpers for this configs repo; run `just` to list them.

set shell := ["bash", "-euo", "pipefail", "-c"]

steam_nm_policy := justfile_directory() / ".configs/systemd/user/steam-fake-nm.conf"
steam_nm_policy_dst := "/etc/dbus-1/system.d/steam-fake-nm.conf"

[private]
default:
    @just --list

# Symlink dotfiles and ~/.config dirs into this repo
links:
    ./setup_links.sh

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
