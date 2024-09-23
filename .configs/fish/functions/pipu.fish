function pipu --wraps='pip install --upgrade-strategy eager -U' --description 'alias pipu pip install --upgrade-strategy eager -U'
    if set -q argv; and set -q argv[1]
        set cmds uv pip install -U --compile-bytecode --resolution highest $argv
        echo "Installing python packages: $cmds"
        $cmds
    end
end
