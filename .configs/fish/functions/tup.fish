function tup
    set -l runo topgrade --disable gem --disable pip3 --disable vim --disable cargo --disable containers --skip-notify
    if type -q mold
        mold --run $runo
    else
        $runo
    end
    pyenv update
end
