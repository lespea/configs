function nodemise
    mise list | rg -o '^npm:\S+' | parallel --bar --tag mise i -qf {}@latest
end
