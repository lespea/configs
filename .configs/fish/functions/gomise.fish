function gomise
    mise list | rg -o '^go:\S+' | parallel mise i -f {}@latest
end
