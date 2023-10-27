function tup
    set -l runo topgrade --disable gem --disable pip3 --disable vim --disable cargo --skip-notify
    if type -q mold
        mold $runo
    else
        $runo
    end
    pyenv update
end
