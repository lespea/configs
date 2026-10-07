function pymise
    mise list | rg -o '^pypi:\S+' | parallel --bar --tag mise i -qf {}@latest
end
