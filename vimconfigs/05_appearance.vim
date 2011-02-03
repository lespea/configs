" ----------------------------------------
" |  Configures the colors/font for vim  |
" ----------------------------------------

"  Basic syntax coloring
syntax on
set background=dark

"  Running gvim
if has("gui_running")
    "  Widnows
    if has("gui_win32")
        set guifont=DejaVu_Sans_Mono:h11

        "  Also use full screen in windows
        autocmd GUIEnter * :simalt ~x

    "  Anything else (Linux)
    else
        set guifont=DejaVu\ Sans\ Mono\ 11
    endif

    "  Gvim color scheme
    let g:zenesque_colors=3
    colorscheme neverland

    "  Anti-alias fonts"
    set antialias

"  Console vim
else
    "  Console vim color scheme
    colorscheme neverland
endif


"  Highlight the current line
set cursorline
