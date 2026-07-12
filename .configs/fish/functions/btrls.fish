function btrls
    sudo btrbk list | rg '.*@(\w+)\.(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d).*' -r '$2-$3-$4 :: $1' | sort | uniq -c
end
