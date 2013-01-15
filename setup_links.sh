#!/usr/bin/env sh

PWD=`pwd`
DEST=~

ln -s ${PWD}/_vimrc         ${DEST}/.vimrc
ln -s ${PWD}/vimfiles       ${DEST}/.vim
ln -s ${PWD}/Fonts          ${DEST}/.fonts
ln -s ${PWD}/.emacs         ${DEST}
ln -s ${PWD}/.bash_aliases  ${DEST}

if [ ! -f ${DEST}/.gitconfig ]; then
    cp ${PWD}/myGitConfig ${DEST}/.gitconfig
fi
