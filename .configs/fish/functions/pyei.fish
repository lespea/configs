function pyei
    set -l pver 3.12.1
    if test (count $argv) -ge 1
        set pver $argv[1]
    end

    set -l cmd

    #  Use mold if we have it
    if type -q mold
        set cmd mold --run
    end

    # Only build for our current processor on arch
    if test -n $IS_ARCH
        set -a cmd \
            env CFLAGS="-march=native -mtune=native -pipe" \
            env CXXFLAGS="-march=native -mtune=native -pipe"
    end

    set -a cmd \
        env MAKE_OPTS="-j12" \
        env CONFIGURE_OPTS="--enable-shared --enable-optimizations --with-computed-gotos" \
        pyenv install -v $pver

    $cmd

end
