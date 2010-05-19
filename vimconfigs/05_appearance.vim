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
        set guifont=Anonymous_Pro:h12

    "  Anything else (Linux)
    else
        set guifont=Anonymous\ Pro\ 12
    endif

    "  Gvim color scheme
    colorscheme molokai

"  Console vim
else
    "  Console vim color scheme
    colorscheme desert256
endif


"  Highlight the current line
set cursorline
