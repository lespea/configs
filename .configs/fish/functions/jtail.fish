function jtail --wraps=journalctl --description 'Follow the journal, minus repetitive noise'
    # Message-level patterns only; everything else from these sources still shows
    set -l noise \
        'unimplemented action=\.color_change' \
        'adjusting page capacity' \
        'OSC \d+ host \(.*\) must be local' \
        'Successfully (made|demoted) thread \d+ of process' \
        'app-ghostty-surface-transient' \
        'Binding loop detected for property "workspaceList"' \
        'WorkspaceSwitcherModel\.qml' \
        'StatusNotifierItem' \
        'error occurred in Get' \
        'RTCControlSocket' \
        'InputWatcher\] Silence' \
        'zwp_linux_dmabuf_v\d+: Got format' \
        'Possible clipping detected' \
        'removing destroyed snapshots from cache' \
        'print\(\) on closed filehandle' \
        'health_status=healthy' \
        '^(Elapsed time|Transferred|Transferring|Checks):' \
        'Duplicate object found in source'

    set -l cmd journalctl -n0 -f -p info -g "^(?!.*("(string join '|' $noise)"))" $argv

    clear
    if type -q tspin
        $cmd | tspin
    else
        $cmd
    end
end
