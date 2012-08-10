" ----------------------------------------
" |  Configures the colors/font for vim  |
" ----------------------------------------

"  Basic syntax coloring
syntax on

"autocmd ColorScheme * highlight EOLWS  ctermbg=darkgreen guibg=darkgreen
"autocmd ColorScheme * highlight PEP8WS ctermbg=darkgreen guibg=darkgreen
set background=dark

"  Running gvim
if has('gui_running')
    "  Widnows
    if has('gui_win32')
        set guifont=DejaVu_Sans_Mono:h11

        "  Also use full screen in windows
        autocmd GUIEnter * :simalt ~x

    "  Mac
    elseif has('gui_macvim')
        set guifont=DejaVu_Sans_Mono:h11

        "  Fullscreen hack for mac"
        set lines=999 columns=999

        "  Turn on light transparency
        set transparency=7

    "  Anything else (Linux)
    else
        set guifont=DejaVu\ Sans\ Mono\ 11
    endif

    "  Gvim color scheme
    colorscheme solarized

    "  Anti-alias fonts"
    set antialias

"  Console vim
else
    "  The windows terminal is utter crap
    if has('win32')
        colorscheme candy
    elseif has('mac')
        colorscheme desert256
    else
        colorscheme solarized
    endif
endif
let g:solarized_visibility='high'


"  Highlight the current line
set cursorline

"  Disable the icon/menu bar
set guioptions-=T
set guioptions-=m

"  Always show the tab bar
set showtabline=2


" augroup vimrcExEOLWS
"     au!
"     highlight EOLWS  ctermbg=darkgreen guibg=darkgreen
"     highlight PEP8WS ctermbg=darkgreen guibg=darkgreen
"     autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/ containedin=ALL
"     autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/ containedin=ALL
"     autocmd FileType python syn match PEP8WS excludenl /^\t\+/ containedin=ALL
" augroup END
