#!/usr/bin/env zsh

if [[ -f "$HOME/.zsh_custom" ]]; then
    source "$HOME/.zsh_custom"
fi

exec dbus-run-session -- /usr/bin/Hyprland
