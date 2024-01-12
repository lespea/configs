function pipnorm --wraps='pipbase && pipu colorama ipython pandas numpy httpie requests' --description 'alias pipnorm pipbase && pipu colorama ipython pandas numpy httpie requests'
  pipbase && pipu colorama ipython pandas numpy httpie requests pyyaml $argv
end
