function plog --wraps='tail -F' --description 'Follow files, colorized as logs'
    if type -q tspin
        tail -F $argv | tspin
    else
        tail -F $argv | bat -pP -llog
    end
end
