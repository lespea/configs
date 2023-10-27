#!/usr/bin/env fish

if set -q IS_ARCH
    fish_add_path -Up \
                      "$HOME/.cargo/bin" \
                      "$HOME/.local/share/coursier/bin" \
                      "/usr/lib/ccache/bin" \
                      "$HOME/go/bin" \
                      "$PNPM_HOME" \
                      "$HOME/bin"
else
end
