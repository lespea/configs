#!/usr/bin/env zsh
SCRIPT_PATH=${${(%):-%N}:A:h}

echo 'Updating ssl certs'
rehash=/usr/local/opt/openssl/bin/c_rehash
if [[ -f "$rehash" ]]; then
    $rehash
fi

which dircolors >/dev/null 2>/dev/null
if [ $? -eq 0  ]; then
    dircolors -b lscolors/LS_COLORS >~/.lscolors
fi

which brew >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    echo 'Updating brew'
    brew upgrade

    which cmake >/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo 'Installing cmake'
        brew install cmake
    fi

    which ninja >/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo 'Installing ninja'
        brew install ninja
    fi

    which go >/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo 'Installing go'
        brew install go
    fi
fi

which yay >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    yay
fi

echo 'Updating configs'
cd "$SCRIPT_PATH"

ahash1=`sha256sum ~/.antigenrc`
phash1=`sha256sum "$SCRIPT_PATH/_vimrc"`

git pull
git submodule update --recursive --init

ahash2=`sha256sum ~/.antigenrc`
phash2=`sha256sum "$SCRIPT_PATH/_vimrc"`

if [ "$ahash1" != "$ahash2" ]; then
    source "$SCRIPT_PATH/antigen/bin/antigen.zsh"
    antigen update
    antigen reset
    antigen cleanup
fi

if [ "$phash1" != "$phash2" ]; then
    nvim +PlugInstall +PlugUpdate +qall
fi
