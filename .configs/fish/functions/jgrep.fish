function jgrep
    rgq $argv | jq | bat -ljson
end
