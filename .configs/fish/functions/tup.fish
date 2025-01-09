function tup
    set -e GITHUB_API_TOKEN
    set -l runo topgrade

    if type -q mold
        mold --run $runo
    else
        $runo
    end

    # if topgrade fails bail out
    or return

    echo -e "\nUpdating rust packages"
    "$HOME/configs/cpkgs.py" install -m
end
