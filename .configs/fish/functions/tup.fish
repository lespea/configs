function tup
    mise self-update -y

    set -l frun mise x -- fnox run --

    set -l runTop $frun topgrade

    if type -q mold
        mold --run $runTop
    else
        runTop
    end

    $frun fish -c setupv

    echo -e "\nUpdating rust packages"
    $frun python "$HOME/configs/cpkgs.py" install -m
end
