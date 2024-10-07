function tup
    set -e GITHUB_API_TOKEN
    set -l runo topgrade
    if type -q mold
        mold --run $runo
    else
        $runo
    end
end
