function jgz
   gunzip -c $argv | jq | bat -ljson
end
