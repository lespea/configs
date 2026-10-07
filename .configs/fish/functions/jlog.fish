function jlog --wraps='journalctl -r -p warning' --description 'alias jlog journalctl -r -p warning'
    journalctl -r -p warning $argv
end
