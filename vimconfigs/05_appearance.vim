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

    "  Anything else (Linux)
    else
        set guifont=DejaVu\ Sans\ Mono\ 11
    endif

    "  Gvim color scheme
    colorscheme tangoshady

"  Console vim
else
    "  Console vim color scheme
    colorscheme desert256
endif


"  Highlight the current line
set cursorline
