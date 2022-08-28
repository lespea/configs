#!/usr/bin/env zsh

ROOT_FOLDER='/rootBackup'
SYNC_FOLDER="$ROOT_FOLDER/sync"

TMP_NAME='TMP_SYNC'
END_NAME='SYNC'

function is_mounted {
    findmnt "$ROOT_FOLDER" | rg -q 'rootB' && [ -d "$SYNC_FOLDER" ]
    return $?
}

function backup {
    set -e

    name="$1"
    src="$2"

    src_snaps=`realpath "$src/.snapshots"`
    src_end="$src_snaps/$END_NAME"
    src_tmp="$src_snaps/$TMP_NAME"

    dst=`realpath "$SYNC_FOLDER/$name"`
    dst_end="$dst/$END_NAME"
    dst_tmp="$dst/$TMP_NAME"

    if [ ! -d "$src_snaps" ]; then
        echo "src snaps ($src_snaps) doesn't exist, aborting!"
        exit 1
    fi
    if [ -d "$src_tmp" ]; then
        echo "tmp src dir ($src_tmp) exists, aborting!"
        exit 1
    fi
    if [ -d "$dst_tmp" ]; then
        echo "tmp dst dir ($dst_tmp) exists, aborting!"
        exit 1
    fi

    set -x
    mkdir -p "$dst"

    if [ -d "$src_end" -a -d "$dst_end" ]; then
        btrfs sub snap -r "$src" "$src_tmp"
        btrfs send -p "$src_end" "$src_tmp" | btrfs receive "$dst"

        if [ ! -d "$dst_end" -o ! -d "$src_end" -o ! -d "$dst_tmp" -o ! -d "$src_tmp" ]; then
            echo "issue detected; aborting"
            exit 1
        fi

        btrfs sub del "$src_end" "$dst_end"
        mv "$src_tmp" "$src_end"
        mv "$dst_tmp" "$dst_end"
    else
        if [ -d "$src_end" ]; then
            btrfs send "$src_end" | btrfs receive "$dst"
            if [ -d "$src_tmp" ]; then
                btrfs sub del "$src_tmp"
            fi
        else
            btrfs sub snap -r "$src" "$src_end"
            btrfs send "$src_end" | btrfs receive "$dst"
        fi
    fi

    set +x
    echo
    set +e
}

if is_mounted; then
    backup home /home
    backup root /
else
    echo not mounted
    exit 1
fi

