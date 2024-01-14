function jtail --wraps='clear && journalctl -n0 -f | rg -M0 -vF rtkit-daemon' --description 'alias jtail clear && journalctl -n0 -f | rg -M0 -vF rtkit-daemon'
  clear && journalctl -n0 -f | rg -M0 -iv --line-buffered 'rtkit-daemon|G_DBUS_PROXY_FLAGS_DO_NOT_AUTO_START' $argv | bat -pP -llog
end
