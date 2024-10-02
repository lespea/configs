function gomise
    mise list | rg -o '^go:\S+' | parallel --bar --tag mise i -qf {}@latest
end
