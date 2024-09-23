function pipu --wraps='pip install --upgrade-strategy eager -U' --description 'alias pipu pip install --upgrade-strategy eager -U'
  uv pip install -U --compile-bytecode --resolution highest $argv
end
