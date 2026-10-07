function jtail --description 'Tail the journal, filtered and colorized'
    clear && journalctl -n0 -f | rg -M0 -iv --line-buffered 'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START|ghostty' | bat -pP -llog
end
