function tup
    mise self-update -y

    set -l frun mise x --

    if type -q allcores
        set frun allcores $frun
    end

    set -l runTop topgrade
    if type -q mold
        set runTop mold --run $runTop
    end

    $frun $runTop

    $frun fish -c setupv

    echo -e "\nUpdating rust packages"
    $frun python "$HOME/configs/cpkgs.py" install -m
end
