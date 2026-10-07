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

    echo -e "\nUpdating rust packages"
    $frun just --justfile "$HOME/configs/justfile" cargo install -m
end
