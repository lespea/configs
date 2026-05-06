function tup
    set -l runTop fnox run -- topgrade

    if type -q mold
        mold --run $runTop
    else
        $runTop
    end

    # if topgrade fails bail out
    # or return

    fnox run -- setupv

    echo -e "\nUpdating rust packages"
    fnox run -- python "$HOME/configs/cpkgs.py" install -m
end
