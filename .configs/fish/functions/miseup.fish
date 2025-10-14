function miseup
    mise list | rg -o '^(?:go|pipx|npm):\S+' | parallel --bar --tag mise i -qf {}@latest
end
