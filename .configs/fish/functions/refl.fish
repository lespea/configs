function refl --wraps="sudo reflector -n 24 -c 'United States' -f 10 -p https --save /etc/pacman.d/mirrorlist --threads 10 -a 12" --description "alias refl sudo reflector -n 24 -c 'United States' -f 10 -p https --save /etc/pacman.d/mirrorlist --threads 10 -a 12"
  sudo-rs reflector -n 24 -c 'United States' -f 10 -p https --save /etc/pacman.d/mirrorlist --threads 10 -a 12 $argv
end
