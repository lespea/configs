function plog --wraps='tail -F' --description 'Follow files, colorized as logs'
    tail -F $argv | bat -pP -llog
end
