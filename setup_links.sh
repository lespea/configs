#!/usr/bin/env bash
CUR_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function setup_link() {
    src="$1"
    dst="$2"

    if [[ "x$1" == "x" ]]; then
        echo no src for setupLink func
        exit 1
    fi

    if [[ "x$2" == "x" ]]; then
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
    if [[ "x$1" == "x" ]]; then
        echo no src for setupLink func
        exit 1
    fi

    src="${CUR_DIR}/$1"
    if [[ -f "$src" ]]; then
        setup_link "$src" "${HOME}/$1"
    else
        echo weird src? $src
        exit 1
    fi
}

mkdir -p "${HOME}/.gnupg"

setup_link "${CUR_DIR}/gpg/gpg.conf"       "${HOME}/.gnupg/gpg.conf"
setup_link "${CUR_DIR}/gpg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"

chmod 600 "${HOME}/.gnupg/gpg.conf" "${HOME}/.gnupg/gpg-agent.conf"


setup_link "${CUR_DIR}/_vimrc"        "${HOME}/.vimrc"
setup_link "${CUR_DIR}/vimfiles"      "${HOME}/.vim"
setup_link "${CUR_DIR}/Fonts"         "${HOME}/.fonts"
setup_link "${CUR_DIR}/redshift.conf" "${HOME}/.config/redshift.conf"

setup_single .gitattributes
setup_single .ideavimrc
setup_single .tmux.conf
setup_single .antidoterc

if [ ! -f ${HOME}/.gitconfig ]; then
    cp ${CUR_DIR}/myGitConfig ${HOME}/.gitconfig
fi

if [[ `uname` == "Darwin" ]]; then
    setup_link "${CUR_DIR}/macAntigen" "${HOME}/.antigenrc"
    setup_link "${CUR_DIR}/macZsh" "${HOME}/.zshrc"
    setup_link "${CUR_DIR}/macZshEnv" "${HOME}/.zshenv"
else
    setup_single .Xresources

    setup_link "${CUR_DIR}/.configs/i3" "${HOME}/.config/i3"
    setup_link "${CUR_DIR}/.configs/picom" "${HOME}/.config/picom"
    setup_link "${CUR_DIR}/.configs/alacritty" "${HOME}/.config/alacritty"

    setup_link "${CUR_DIR}/archAntigen" "${HOME}/.antigenrc"
    setup_link "${CUR_DIR}/archZsh" "${HOME}/.zshrc"
    setup_link "${CUR_DIR}/archZshEnv" "${HOME}/.zshenv"
    setup_link "${CUR_DIR}/archP10K" "${HOME}/.p10k.zsh"
fi

setup_link "${CUR_DIR}/nvim" "${HOME}/.config/nvim"

