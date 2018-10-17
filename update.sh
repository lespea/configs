#!/usr/bin/env bash
CONF="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 'Updating brew'
brew upgrade --outdated

which cmake >/dev/null
if [ $? -ne 0 ]; then
    echo 'Installing cmake'
    brew install cmake
fi

which ninja >/dev/null
if [ $? -ne 0 ]; then
    echo 'Installing ninja'
    brew install ninja
fi

which go >/dev/null
if [ $? -ne 0 ]; then
    echo 'Installing go'
    brew install go
fi

which node >/dev/null
if [ $? -ne 0 ]; then
    echo 'Installing node'
    brew install node
fi

echo 'Updating rust'
rustup update

echo 'Updating oh my zsh'
cd "$HOME/.oh-my-zsh"
git pull

echo 'Updating configs'
cd "$CONF"
git pull
git submodule update --recursive --init

echo 'Updating vim plugins'
ycm="$CONF/vimfiles/bundle/YouCompleteMe"
cd "$ycm"
python3 ./install.py --go-completer --rust-completer  --clang-completer --java-completer --js-completer --ninja
cd "$ycm/third_party/ycmd/third_party/racerd"
git reset . >/dev/null
git checkout .
git clean -f -d
cd "$ycm/third_party/ycmd/third_party/cregex"
git reset . >/dev/null
git checkout .
git clean -f -d
