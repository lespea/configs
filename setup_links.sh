#!/usr/bin/env bash
CUR_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

mkdir -p ${HOME}/.config

# Install oh-my-zsh
install_omz=y
if [[ -d "$OH_MY_ZSH_DIR" ]]; then
    cd "$OH_MY_ZSH_DIR"
    git pull
    if [ $? -eq 0 ]; then
        install_omz=n
    else
        rm -rf "$OH_MY_ZSH_DIR"
        install_omz=y
    fi
    cd "$CUR_DIR"
else
    install_omz=y
fi

if [[ "$install_omz" == "y" ]]; then
    echo "Installing oh my zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh my zsh up to date"
fi

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

    if [[ -d "$dst" ]]; then
        rm -rf "$dst"
    elif [[ -f "$dst" ]]; then
        rm -f "$dst"
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
        echo weird src?
        exit 1
    fi
}

setup_link "${CUR_DIR}/_vimrc"        "${HOME}/.vimrc"
setup_link "${CUR_DIR}/vimfiles"      "${HOME}/.vim"
setup_link "${CUR_DIR}/Fonts"         "${HOME}/.fonts"

setup_single .emacs
setup_single .bash_aliases
setup_single .gitattributes
setup_single .ctags
setup_single .ideavimrc

if [ ! -f ${HOME}/.gitconfig ]; then
    cp ${CUR_DIR}/myGitConfig ${HOME}/.gitconfig
fi

rm -f ${HOME}/.zshrc
if [[ `uname` -eq "Darwin" ]]; then
    setup_link "${CUR_DIR}/.zshrc_mac" "${HOME}/.zshrc"
else
    setup_single "${CUR_DIR}/.Xresources"

    setup_link "${CUR_DIR}/.zshrc_arch" "${HOME}/.zshrc"
    setup_link "${CUR_DIR}/.configs/i3" "${HOME}/.config/i3"
fi

setup_link "${CUR_DIR}/vimfiles" "${HOME}/.config/nvim"

#\curl -L https://install.perlbrew.pl | bash
#perlbrew install perl-5.22.4 --thread --multi --64int --64all --ld --clang
