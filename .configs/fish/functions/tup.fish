function tup
    set -l runTop topgrade

    if type -q mold
        mold --run $runTop
    else
        $runTop
    end

    # if topgrade fails bail out
    # or return

    setupv

    echo -e "\nUpdating rust packages"
    "$HOME/configs/cpkgs.py" install -m
end
