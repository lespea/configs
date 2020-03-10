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

    which node >/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo 'Installing node'
        brew install node
    fi
fi

which yay >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    yay
fi

echo 'Updating oh my zsh'
cd "$HOME/.oh-my-zsh"
git pull

ycm="$SCRIPT_PATH/vimfiles/bundle/YouCompleteMe"
cd "$ycm"
OLD_YCM=`git rev-parse HEAD`

echo 'Updating configs'
cd "$SCRIPT_PATH"
git pull
git submodule update --recursive --init

./cleanup.sh

args="--all"

which ninja >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    args="$args --ninja"
fi

echo 'Updating vim plugins'
cd "$ycm"

NEW_YCM=`git rev-parse HEAD`

if [ $UPD_RUST -ne 0 ] || [ "$NEW_YCM" != "$OLD_YCM" ] || [ "z$1z" = "z1z" ]; then 
    python3 ./install.py ${=args}
else
    echo "Not rebuilding YCM because nothing changed"
fi

source "$SCRIPT_PATH/antigen/bin/antigen.zsh"
antigen update
antigen reset
antigen cleanup
