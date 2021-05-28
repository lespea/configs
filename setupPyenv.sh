#!/usr/bin/bash

git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git "$HOME/.pyenv/plugins/pyenv-virtualenv"
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git "$HOME/.pyenv/plugins/pyenv-virtualenvwrapper"
git clone https://github.com/pyenv/pyenv-update.git "$HOME/.pyenv/plugins/pyenv-update"
git clone https://github.com/pyenv/pyenv-pip-migrate.git "$HOME/.pyenv/plugins/pyenv-pip-migrate"

#git submodule add https://github.com/pyenv/pyenv-virtualenv.git "$HOME/.pyenv/plugins/pyenv-virtualenv"
#git submodule add https://github.com/pyenv/pyenv-virtualenvwrapper.git "$HOME/.pyenv/plugins/pyenv-virtualenvwrapper"
#git submodule add https://github.com/pyenv/pyenv-update.git "$HOME/.pyenv/plugins/pyenv-update"
#git submodule add https://github.com/pyenv/pyenv-pip-migrate.git "$HOME/.pyenv/plugins/pyenv-pip-migrate"
#git submodule update --init --recursive
