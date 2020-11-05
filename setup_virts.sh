#!/usr/bin/env bash

pip3 install --upgrade virtualenvwrapper --user

source `which virtualenvwrapper.sh`

rm -rf ~/.virtualenvs/main  2>/dev/null
rm -rf ~/.virtualenvs/nvim3 2>/dev/null

mkvirtualenv main -p python3
mkvirtualenv nvim3 -p python3

~/.virtualenvs/main/bin/pip  install colorama numpy ipython requests pandas
~/.virtualenvs/nvim3/bin/pip install colorama neovim yapf

