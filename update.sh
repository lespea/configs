#!/usr/bin/env bash
CONF="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 'Updating ssl certs'
if [[ -f "$rehahsh" ]]; then
    rehahsh=/usr/local/opt/openssl/bin/c_rehash
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

ycm="$CONF/vimfiles/bundle/YouCompleteMe"
cd "$ycm"
OLD_YCM=`git rev-parse HEAD`

echo 'Updating configs'
cd "$CONF"
git pull
git submodule update --recursive --init

./cleanup.sh

args="--java-completer --clang-completer"

UPD_RUST=0
which rustup >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    OLD_RUSTV=`rustc --version`
    echo 'Updating rust'
    rustup update
    args="$args --rust-completer"
    NEW_RUSTV=`rustc --version`

    if [ "$OLD_RUSTV" != "$NEW_RUSTV" ]; then
        UPD_RUST=1
    fi
fi

which go >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    args="$args --go-completer"
fi

which node >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    args="$args --js-completer"
fi

which ninja >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    args="$args --ninja"
fi

echo 'Updating vim plugins'
cd "$ycm"

NEW_YCM=`git rev-parse HEAD`

if [ $UPD_RUST -ne 0 -o "$NEW_YCM" != "$OLD_YCM" -o "z$1z" == "z1z" ]; then 
    python3 ./install.py $args
    cd "$ycm/third_party/ycmd/third_party/racerd"
    git reset . >/dev/null
    git checkout .
    git clean -f -d
    cd "$ycm/third_party/ycmd/third_party/cregex"
    git reset . >/dev/null
    git checkout .
    git clean -f -d
else
    echo "Not rebuilding YCM because nothing changed"
fi
