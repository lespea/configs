" ----------------------------------------
" |  Configures the colors/font for vim  |
" ----------------------------------------

"  Basic syntax coloring
syntax on

autocmd ColorScheme * highlight EOLWS  ctermbg=darkgreen guibg=darkgreen
autocmd ColorScheme * highlight PEP8WS ctermbg=darkgreen guibg=darkgreen
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
    colorscheme darkZ

    "  Anti-alias fonts"
    set antialias

"  Console vim
else
    "  Console vim color scheme
    colorscheme darkZ
endif


"  Highlight the current line
set cursorline

"  Disable the icon/menu bar
set guioptions-=T
set guioptions-=m

"  Always show the tab bar
set showtabline=2


augroup vimrcExEOLWS
    au!
    highlight EOLWS  ctermbg=darkgreen guibg=darkgreen
    highlight PEP8WS ctermbg=darkgreen guibg=darkgreen
    autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/ containedin=ALL
    autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/ containedin=ALL
    autocmd FileType python syn match PEP8WS excludenl /^\t\+/ containedin=ALL
augroup END
