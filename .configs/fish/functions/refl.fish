function refl --description 'Refresh the pacman mirrorlist'
    sudo reflector -n 24 -c 'United States' -f 10 -p https --save /etc/pacman.d/mirrorlist --threads 10 -a 12 $argv
end
