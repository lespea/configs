function jtail --wraps="clear && journalctl -n0 -f | rg -M0 -iv --line-buffered 'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START' \$argv | bat -pP -llog" --description "alias jtail clear && journalctl -n0 -f | rg -M0 -iv --line-buffered 'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START' \$argv | bat -pP -llog"
  clear && journalctl -n0 -f | rg -M0 -iv --line-buffered 'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START' $argv | bat -pP -llog $argv
        
end
