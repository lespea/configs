function jtail --wraps='clear && journalctl -n0 -f | rg -M0 -vF rtkit-daemon' --description 'alias jtail clear && journalctl -n0 -f | rg -M0 -vF rtkit-daemon'
  clear && journalctl -n0 -f | rg -M0 -vF --line-buffered rtkit-daemon $argv | bat -pP -llog
end
