function pvcp -d 'Use pv to copy files'
    if not test (count $argv) -ge 2
        echo 'Need at least 2 args'
        return 1
    end

    set -l dst (path normalize $argv[-1])
    set -l srcs $argv[..-2]

    if path is --type=dir $dst
        if not path is --type=dir --perm=write $dst
            echo 'No write permissions for dst'
            return 1
        end

    else if path is --type=file $dst; or test (count $srcs) -eq 1
        if test (count $srcs) -eq 1
            _pvcp $srcs[1] $dst
            return $status
        else
            echo 'Dst is a file and there are multiple srcs; aborting'
            return 1
        end

    else
        if read -P "Dst dir '$dst' doesn't exist; create it? " | string match -q -i 'y'
            mkdir -p $dst
        else
            echo "Aborting..."
            return 1
        end
    end

    for src in $srcs
        _pvcp $src (path resolve "$dst/$src")
    end
end

function _pvcp -a src -a dst
    if path is --type=file --perm=read $src
        echo "Copying $src => $dst"
        pv $src > $dst
        echo
        return 0
    else
        echo "Skipping '$src' as it's not a readable file"
        return 1
    end
end
