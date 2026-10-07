#!/usr/bin/env bash
CUR_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function setup_link() {
    src="$1"
    dst="$2"

    if [[ -z "$1" ]]; then
        echo no src for setupLink func
        exit 1
    fi

    if [[ -z "$2" ]]; then
        echo no dst for setupLink func
        exit 1
    fi

    if [ -d "$dst" ]; then
        echo "Removing $dst"
        rm -rf "$dst"
    elif [ -L "$dst" ] || [ -e "$dst" ]; then
        echo "Removing $dst"
        rm -f "$dst"
    else
        echo "NOT removing $dst"
    fi

    ln -s "$src" "$dst"
}

function setup_single() {
    if [[ -z "$1" ]]; then
        echo no src for setupLink func
        exit 1
    fi

    src="${CUR_DIR}/$1"
    if [[ -f "$src" ]]; then
        setup_link "$src" "${HOME}/$1"
    else
        echo "weird src? $src"
        exit 1
    fi
}

setup_single .gitattributes
setup_single .ideavimrc
setup_single .tmux.conf
setup_single .ripgreprc

BOTH_DIRS="alacritty atuin bat bottom broot btop fish ghostty htop kitty lazygit lsd mise mpv nushell pueue rmpc starship.toml taplo topgrade.d zellij"

if [[ $(uname) == "Darwin" ]]; then
    CONF_DIRS="$BOTH_DIRS"
else
    CONF_DIRS="$BOTH_DIRS cava DankMaterialShell gamemode.ini hypr MangoHud mpd paru picom pipewire sway systemd uwsm waybar wpaperd xdg-desktop-portal"

    setup_single .Xresources
fi

setup_link "${CUR_DIR}/nvim" "${HOME}/.config/nvim"

for dir in $CONF_DIRS; do
    setup_link "$CUR_DIR/.configs/$dir" "$HOME/.config/$dir"
done
