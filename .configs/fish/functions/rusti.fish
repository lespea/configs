function rusti --wraps='mold --run env RUSTFLAGS="-C link-args=-s -C target-cpu=native" cargo install' --description 'alias rusti mold --run env RUSTFLAGS="-C link-args=-s -C target-cpu=native" cargo install'
    set -l mrun
    if type -q mold
        set mrun mold --run
    end

    set -a mrun env RUSTFLAGS="-C link-args=-s -C target-cpu=native" cargo install $argv

    echo $mrun
    $mrun
end
