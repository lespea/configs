function agebak
    set -l name $argv[1]
    set -l dirs $argv[2..-1]

    if not string length -q $name
        echo 'Unknown name'
        return
    else if test -d $name
        echo "Output name $name is a dir; make sure the first arg is the name not a dir"
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
        if not test -d $dir && not test -f $dir
            echo "Unknown dir $dir"
            return
        end
    end

    set -l day (date '+%Y-%m-%d')
    set -l out (string join '' $name '_' $day '.tar.zstd.age')

    set -l in_size (dust -o b -j $dirs | jq -r '.size' | sd 'B$' '')

    set -l c_tar tar cf - $dirs
    set -l pv_tar pv -cN tar -B (math 2 ^ 24) -s $in_size

    set -l c_zstd zstd --long -15 -T0
    set -l pv_zstd pv -cN zstd

    set -l c_age age -e -r $AGE_KEY
    set -l pv_age pv -cN age

    echo "$c_tar | $pv_tar | $c_zstd | $pv_zstd | $c_age | $pv_age >$out"
    $c_tar | $pv_tar | $c_zstd | $pv_zstd | $c_age | $pv_age >$out
end
