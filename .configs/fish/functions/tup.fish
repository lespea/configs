function tup
    set -e GITHUB_API_TOKEN
    set -l runo topgrade --disable gem --disable pip3 --disable vim --disable cargo --disable containers --skip-notify
    if type -q mold
        mold --run $runo
    else
        $runo
    end
end
