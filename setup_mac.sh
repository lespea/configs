#!/usr/bin/env bash
CUR_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

mkdir -p ${HOME}/configs

# Setup brew if not installed
which brew >/dev/null
if [ $? -ne 0 ]; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew already installed"
fi

if [[ ! -d '/usr/local/opt/openssl/' ]]; then
   echo 'Install openssl'
   brew install openssl
fi

if [[ ! -d '/usr/local/opt/curl' ]]; then
   echo 'Installing curl'
   brew install curl --with-libssh2 --with-nghttp2 --with-openssl
fi

# Install required brew packages for setup
which git >/dev/null
if [ $? -ne 0 ]; then
    brew install git --with-curl --with-openssl
fi

which zsh >/dev/null
if [ $? -ne 0 ]; then
    brew install zsh --with-pcre
fi

which htop >/dev/null
if [ $? -ne 0 ]; then
    brew install htop --with-ncurses
fi

which python3 >/dev/null
if [ $? -ne 0 ]; then
    brew install python
fi

which python2 >/dev/null
if [ $? -ne 0 ]; then
    brew install python2
fi

which cmake >/dev/null
if [ $? -ne 0 ]; then
    brew install cmake
fi

CARGO_ENV="$HOME/.cargo/env"
if [[ -f "$CARGO_ENV" ]]; then
    source "$CARGO_ENV"
fi

which cargo >/dev/null
if [ $? -ne 0 ]; then
    brew install rustup
    rustup-init
    source "$CARGO_ENV"
fi
which exa >/dev/null
if [ $? -ne 0 ]; then
    RUSTFLAGS="-C target-cpu=native -C link-args=-s" cargo install exa --features git
fi
which rg >/dev/null
if [ $? -ne 0 ]; then
    RUSTFLAGS="-C target-cpu=native -C link-args=-s" cargo install ripgrep --features simd-accel,avx-accel
fi
which fd >/dev/null
if [ $? -ne 0 ]; then
    RUSTFLAGS="-C target-cpu=native -C link-args=-s" cargo install fd-find
fi
which exa >/dev/null
if [ $? -ne 0 ]; then
    RUSTFLAGS="-C target-cpu=native -C link-args=-s" cargo install exa
fi

# Setup pip
pip3 install --upgrade pip setuptools wheel
pip2 install --upgrade pip setuptools wheel

"$CUR_DIR"/setup_links.sh
"$CUR_DIR"/setup_virts.sh
"$CUR_DIR"/update.sh

#brew bundle install --file="$CUR_DIR/Brewfile"
