#!/usr/bin/env fish

#set -Ux IS_ARCH true
#set -Ux IS_MAC  true

# PATH first so the tools used below (vivid, ...) can be found on a fresh machine
source (status dirname)/paths.fish

# set -Ux PYENV_ROOT "$HOME/.pyenv"
# fish_add_path -Up "$PYENV_ROOT/bin"

set -Ux EDITOR nvim
set -Ux SYSTEMD_EDITOR nvim

if type -q vivid
    set -Ux LS_COLORS "$(vivid generate one-dark)"
end

set -Ux PNPM_HOME "$HOME/.local/share/pnpm"

set -U fish_greeting

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
alias -s sbtb 'sbt --mem 7168 -J-XX:MaxGCPauseMillis=1000 -J-XX:+UseStringDeduplication -J-XX:+AlwaysPreTouch'

# real function for now
# alias -s rusti 'mold --run env RUSTFLAGS="-C link-args=-s -C target-cpu=native" cargo install'

# ls

set -l ezaBin eza -g --icons --binary

alias -s ls "$ezaBin"

alias -s l "$ezaBin -G"
alias -s la "$ezaBin -a"

alias -s lla "$ezaBin -la"
alias -s ll "$ezaBin -l"
alias -s lld "$ezaBin -l --total-size"

alias -s lt "$ezaBin -T"
alias -s llt "$ezaBin -l -T"
alias -s llta "$ezaBin -la -T"

alias -s ip 'ip -c'

## Globals

#set -Ux JAVA_HOME /usr/lib/jvm/default
set -Ux MAKEFLAGS -j(getconf _NPROCESSORS_ONLN)

set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_DESKTOP_DIR "$HOME/Desktop"
set -Ux XDG_DOCUMENTS_DIR "$HOME/Documents"
set -Ux XDG_DOWNLOAD_DIR "$HOME/Downloads"
set -Ux XDG_MUSIC_DIR "$HOME/Music"
set -Ux XDG_PICTURES_DIR "$HOME/Pictures"
set -Ux XDG_VIDEOS_DIR "$HOME/Videos"

## Env (universal so every fish process gets them, not just interactive shells)

set -Ux JAVA_OPTS '-XX:+UseG1GC -Xmx3G -XX:MaxInlineLevel=21 --enable-native-access=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED'
set -Ux SBT_OPTS '-Xss1M -XX:ReservedCodeCacheSize=512m'

set -Ux TAPLO_CONFIG "$XDG_CONFIG_HOME/taplo/taplo.toml"
set -Ux RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

set -Ux CMAKE_GENERATOR Ninja
set -Ux PUPPETEER_SKIP_DOWNLOAD 1

if set -q IS_ARCH
    set -Ux USE_CODEIUM 1
else
    set -Ux LANG en_US.UTF-8
end

set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -Ux MANROFFOPT -c

set -l age_key "$XDG_DATA_HOME/.ak/.dat"
set -Ux FNOX_AGE_KEY_FILE $age_key
set -Ux SOPS_AGE_KEY_FILE $age_key

set -Ux MISE_LIBC gnu
set -Ux SYSTEMD_TINT_BACKGROUND 0

set -U fish_transient_prompt 1

## Theme

# Persist the dark variant of themes/token.theme as universal colors; skips the per-startup `fish_config theme choose`
set -l theme_file (status dirname)/themes/token.theme
set -l theme_section
while read -l line
    switch $line
        case '' '#*'
            continue
        case '[*]'
            set theme_section $line
        case '*'
            test "$theme_section" = '[dark]'; or continue
            set -l kv (string split -m 1 ' ' -- $line)
            set -U -- $kv[1] (string split ' ' -- $kv[2])
    end
end <$theme_file

if set -q IS_ARCH
    alias -s icat 'kitty +kitten icat'
    # alias -s kssh 'kitty +kitten ssh'
    alias -s jlog 'journalctl -r -p warning'
    alias -s jtail "clear && journalctl -n0 -f | rg -M0 -iv --line-buffered 'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START|ghostty' | bat -pP -llog"
    alias -s refl "sudo reflector -n 24 -c 'United States' -f 10 -p https --save /etc/pacman.d/mirrorlist --threads 10 -a 12"
    alias -s rhtop 'run0 --empower htop'
    # plog is a real function (functions/plog.fish): alias appends $argv at the end, but the files have to go to `tail`

    for dir in Desktop Documents Downloads Music Pictures Video
        mkdir -p "$HOME/$dir"
    end
else if set -q IS_MAC
    set -Ux GOPRIVATE "*.target.com"
end
