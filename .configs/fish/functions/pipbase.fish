function pipbase --wraps='pipu pip && pipu setuptools wheel' --description 'alias pipbase pipu pip && pipu setuptools wheel'
  pipu pip && pipu setuptools wheel $argv
end
