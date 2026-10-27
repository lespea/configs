# Persist the dark variant of the vendored token-meridian theme (`just sync-token`) as universal colors; skips the
# per-startup `fish_config theme choose`. `path resolve` follows ~/.config/fish back into the repo.
# Sourced by setup.fish; `just token-apply` runs it on its own after a sync
set -l theme_file (path resolve (status dirname)/../..)/token-contrib/fish/token-meridian.theme
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
