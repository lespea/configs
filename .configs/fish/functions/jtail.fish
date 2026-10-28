function jtail --wraps=journalctl --description 'Follow the journal, minus repetitive noise'
    # Message-level patterns only; everything else from these sources still shows
    set -l noise \
        "Failed to realize renderer 'GskVulkanRenderer'" \
        '(Processing|Building) theme: hex|Setting desired theme - hex mode' \
        '(Running|with) matugen|Matugen worker completed' \
        '^(Elapsed time|Transferred|Transferring|Checks):' \
        'adjusting page capacity' \
        app-ghostty-surface-transient \
        'Binding loop detected for property "workspaceList"' \
        'CSI \w+ with (unimplemented|intermediate)' \
        'Duplicate object found in source' \
        'error occurred in Get' \
        'found Ghostty resources dir' \
        'health_status=healthy' \
        'InputWatcher\] Silence' \
        'loaded OpenGL \d' \
        'OSC \d+ host \(.*\) must be local' \
        'Possible clipping detected' \
        'print\(\) on closed filehandle' \
        'pty fd closed, read thread exiting' \
        'QWaylandTextInputv3::disableSurface' \
        'radv is not a conformant Vulkan implementation' \
        'removing destroyed snapshots from cache' \
        RTCControlSocket \
        'shell integration automatically injected' \
        'started subcommand path=' \
        StatusNotifierItem \
        'Successfully (made|demoted) thread \d+ of process' \
        'surface closed addr=' \
        'Theme generation completed|No color changes detected, skipping refresh' \
        'unimplemented action=\.' \
        'WorkspaceSwitcherModel\.qml' \
        'zwp_linux_dmabuf_v\d+: Got format'

    set -l cmd journalctl -n0 -f -p info -g "^(?!.*("(string join '|' $noise)"))" $argv

    clear
    if type -q tspin
        $cmd | tspin
    else
        $cmd
    end
end
