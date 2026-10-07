function plog --wraps='tail -F $argv | bat -pP -llog' --description 'alias plog tail -F $argv | bat -pP -llog'
    tail -F $argv | bat -pP -llog $argv
end
