function agebak
    set -l name $argv[1]
    set -l dirs $argv[2..-1]

    if not string length -q $name
        echo 'Unknown name'
        return
    end

    if not string length -q $AGE_KEY
        echo 'No age key?'
        return
    end

    if not set -q dirs[1]
        echo 'No dirs given'
        return
    end

    for dir in $dirs
        if not test -d $dir
            echo "Unknown dir $dir"
            return
        end
    end

    set -l day (date '+%Y-%m-%d')
    set -l out (string join '' $name '_' $day '.tar.zstd.age')

    tar cf - $dirs | pv -cN tar -B (math 2 ^ 24) -s (gdu -scb $dirs | tail -n1 | cut -f1) | zstd --long -15 -T0 | pv -cN zstd | age -e -r $AGE_KEY | pv -cN age >$out
end
