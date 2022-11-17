#!/usr/bin/env zsh

if [[ -f "$HOME/.zsh_custom" ]]; then
    source "$HOME/.zsh_custom"
fi

export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
# export WLR_RENDERER=vulkan
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

exec dbus-run-session -- /usr/bin/sway
