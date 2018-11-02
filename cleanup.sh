#!/usr/bin/env bash
CONF="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function cleanup_sub() {
    dir="$1"

    if [[ "x$dir" = "x" ]];then
        echo "Gave an empty module name"
        exit 1
    fi

    if [[ -d "$CONF/.git/modules/vimfiles/bundle/$dir" ]];then
        echo rm -rf "$CONF/.git/modules/vimfiles/bundle/$dir"
        rm -rf "$CONF/.git/modules/vimfiles/bundle/$dir"
    fi

    if [[ -d "$CONF/vimfiles/bundle/$dir" ]];then
        echo rm -rf "$CONF/vimfiles/bundle/$dir"
        rm -rf "$CONF/vimfiles/bundle/$dir"
    fi
}

cleanup_sub 'Ansible'
