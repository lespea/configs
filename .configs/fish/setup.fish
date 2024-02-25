#!/usr/bin/env fish

#set -Ux IS_ARCH true
#set -Ux IS_MAC  true

set -Ux PYENV_ROOT "$HOME/.pyenv"
fish_add_path -Up "$PYENV_ROOT/bin"

set -Ux EDITOR nvim
set -Ux SYSTEMD_EDITOR nvim
# set -Ux base16_theme onedark

set -Ux LS_COLORS "$($HOME/.cargo/bin/vivid generate one-dark)"

set -Ux PNPM_HOME "$HOME/.local/share/pnpm"

set -Ux fish_greeting ""

##### Aliases

alias -s cp 'coreutils cp -g --reflink=auto'
alias -s mv 'coreutils mv -g'
alias -s df 'df -h'
alias -s du 'du -h'
alias -s gitk 'gitk --all'
alias -s p pnpm
alias -s rga 'rg -M0'
alias -s rgq 'rg --no-filename --no-heading -N -M0'
alias -s vim nvim
alias -s xsv qsv

alias -s gcola 'git-cola &>/dev/null & disown'

# real function for now
# alias -s rusti 'mold --run env RUSTFLAGS="-C link-args=-s -C target-cpu=native" cargo install'

# ls

alias -s ls 'eza -g --icons=auto'

alias -s l 'exa -g --icons=auto -G'
alias -s la 'exa -g --icons=auto -a'

alias -s lla 'exa -g --icons=auto -la'
alias -s ll 'exa -g --icons=auto -l'
alias -s lld 'exa -g --icons=auto -l --total-size'

alias -s lt 'exa -g --icons=auto -T'
alias -s llt 'exa -g --icons=auto -l -T'
alias -s llta 'exa -g --icons=auto -la -T'

## Globals

#set -Ux JAVA_HOME /usr/lib/jvm/default
set -Ux MAKEFLAGS -j12

set -Ux XDG_CACHE_HOME    "$HOME/.cache"
set -Ux XDG_CONFIG_HOME   "$HOME/.config"
set -Ux XDG_DATA_HOME     "$HOME/.local/share"
set -Ux XDG_DESKTOP_DIR   "$HOME/Desktop"
set -Ux XDG_DOCUMENTS_DIR "$HOME/Documents"
set -Ux XDG_DOWNLOAD_DIR  "$HOME/Downloads"
set -Ux XDG_MUSIC_DIR     "$HOME/Music"
set -Ux XDG_PICTURES_DIR  "$HOME/Pictures"
set -Ux XDG_VIDEOS_DIR    "$HOME/Videos"

if set -q IS_ARCH
    alias -s icat 'kitty +kitten icat'
    alias -s kssh 'kitty +kitten ssh'
    alias -s jlog 'journalctl -r -p warning'
    alias -s plog 'tail -F $argv | bat -pP -llog'
    alias -s jtail 'clear && journalctl -n0 -f | rg -M0 -iv --line-buffered \'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START\' $argv | bat -pP -llog'
    alias -s refl 'sudo reflector -n 24 -c \'United States\' -f 10 -p https --save /etc/pacman.d/mirrorlist --threads 10 -a 12'

    for dir in 'Desktop' 'Documents' 'Downloads' 'Music' 'Pictures' 'Video'
        mkdir -p "$HOME/$dir"
    end
else
end

./paths.fish
