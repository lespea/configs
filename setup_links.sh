#!/usr/bin/env sh

PWD=`pwd`
DEST=~

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -rf ${DEST}/.vimrc
rm -rf ${DEST}/.vim
rm -rf ${DEST}/.fonts
rm -f ${DEST}/.emacs
rm -f ${DEST}/.bash_aliases

ln -s ${PWD}/_vimrc         ${DEST}/.vimrc
ln -s ${PWD}/vimfiles       ${DEST}/.vim
ln -s ${PWD}/Fonts          ${DEST}/.fonts
ln -s ${PWD}/.emacs         ${DEST}
ln -s ${PWD}/.bash_aliases  ${DEST}

if [ ! -f ${DEST}/.gitconfig ]; then
    cp ${PWD}/myGitConfig ${DEST}/.gitconfig
fi

rm -f ${DEST}/.zshrc
ln -s ${PWD}/.zshrc_mac  ${DEST}/.zshrc

mkdir -p ${DEST}/.config
ln -s ${PWD}/vimfiles ${DEST}/.config/nvim

ln -s /usr/local/bin/python2 /usr/local/bin/python

pip3 install virtualenvwrapper
mkvirtualenv nvim2 -p python2
mkvirtualenv nvim3 -p python3
mkvirtualenv main2 -p python2
mkvirtualenv main -p python3

~/.virtualenvs/main2/bin/pip install ipython request
~/.virtualenvs/main/bin/pip install ipython request

~/.virtualenvs/nvim2/bin/pip install neovim
~/.virtualenvs/nvim3/bin/pip install neovim

\curl -L https://install.perlbrew.pl | bash
perlbrew install perl-5.22.4 --thread --multi --64int --64all --ld --clang
