#!/usr/bin/env sh

pip3 install virtualenvwrapper

source `which virtualenvwrapper.sh`

rm -rf ~/.virtualenvs/main
rm -rf ~/.virtualenvs/main2
rm -rf ~/.virtualenvs/nvim2
rm -rf ~/.virtualenvs/nvim3

mkvirtualenv nvim2 -p python2
mkvirtualenv nvim3 -p python3

mkvirtualenv main -p python3
mkvirtualenv main2 -p python2

~/.virtualenvs/main2/bin/pip install ipython request
~/.virtualenvs/main/bin/pip install ipython request

~/.virtualenvs/nvim2/bin/pip install neovim yapf
~/.virtualenvs/nvim3/bin/pip install neovim yapf

