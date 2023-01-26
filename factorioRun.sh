#!/usr/bin/env bash

export HUGEADM_PAGESZ=16384
export HUGEADM_POOLSIZE=2097152

export LIBMIMALLOC_PATH='/usr/lib/libmimalloc.so'
export FACTORIO_PATH="${HOME}/.local/share/Steam/steamapps/common/Factorio"

export MIMALLOC_LARGE_OS_PAGES=1 # Use 2MiB pages
export MIMALLOC_RESERVE_HUGE_OS_PAGES=0 # Use n 1GiB pages
export MALLOC_ARENA_MAX=1 # Tell Glibc to only allocate memory in a single "arena".
export MIMALLOC_PAGE_RESET=0 # Signal when pages are empty
export MIMALLOC_EAGER_COMMIT_DELAY=4 # The first 4MiB of allocated memory won't be hugepages
export MIMALLOC_SHOW_STATS=0 # Display mimalloc stats
export LD_PRELOAD="${LD_PRELOAD} ${LIBMIMALLOC_PATH}"

"${FACTORIO_PATH}/bin/x64/factorio" >"${HOME}/.factorio.log" 2>&1 &!

exit 0
