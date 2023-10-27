#!/usr/bin/env fish

#set -Ux IS_ARCH true
#set -Ux IS_MAC  true

set -Ux PYENV_ROOT "$HOME/.pyenv"
fish_add_path -Up "$PYENV_ROOT/bin"

set -Ux EDITOR nvim
set -Ux SYSTEMD_EDITOR nvim
set -Ux base16_theme onedark

set -Ux LS_COLORS "$($HOME/.cargo/bin/vivid generate one-dark)"

set -Ux PNPM_HOME "$HOME/.local/share/pnpm"

##### Aliases

alias -s cp 'cp --reflink=auto'
alias -s df 'df -h'
alias -s du 'du -h'
alias -s gitk 'gitk --all'
alias -s p pnpm
alias -s rga 'rg -M0'
alias -s rgq 'rg --no-filename --no-heading -N -M0'
alias -s vim nvim
alias -s xsv qsv

alias -s gcola 'git-cola &>/dev/null & disown'
alias -s rusti 'mold --run env RUSTFLAGS="-C link-args=-s -C target-cpu=native" cargo install'

# ls

alias -s ls 'lsd'

alias -s l 'lsd'
alias -s la 'lsd -a'

alias -s lla 'lsd -la'
alias -s ll 'lsd -l'
alias -s lld 'lsd -l --total-size'

alias -s lt 'lsd --tree'
alias -s llt 'lsd -l --tree'
alias -s llta 'lsd -la --tree'

## Abbreviations

abbr --add GA -p anywhere '| rg -M0'
abbr --add L -p anywhere '| bat'
abbr --add LC -p anywhere '| wc -l'
abbr --add LP -p anywhere '| bat -p'
abbr --add UC -p anywhere '| sort | uniq -c | sort -rh'
abbr --add WC -p anywhere '| wc -l'

## Globals

set -Ux JAVA_HOME /usr/lib/jvm/default
set -Ux MAKEFLAGS -j20

if set -q IS_ARCH
    alias -s icat 'kitty +kitten icat'
    alias -s kssh 'kitty +kitten ssh'
else
end

./paths.fish
