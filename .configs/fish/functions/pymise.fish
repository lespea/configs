function pymise
    mise list | rg -o '^pipx:\S+' | parallel --bar --tag mise i -qf {}@latest
end
