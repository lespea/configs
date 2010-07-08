"  ------------------------------------
"  |  Setup the basic options of vim  |
"  ------------------------------------

"  Setup mouse & keyboard standard across all platforms
behave xterm

"  Mouse has popup menus
set mousemodel=popup

"  Save last 50 search history items, last 50 edit marks, don't remember search highlights
set viminfo=/50,'50,h

"  Make backspace work
set backspace=indent,eol,start

"  Show line numbers
set number

"  Show matching brackets.
set showmatch

"  Have % bounce between angled brackets, as well as the other kinds:
set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-

"  This being the 21st century, I use Unicode
set encoding=utf-8

"  Don't keep a backup file
set nobackup

"  Keep 100 lines of command line history
set history=100

"  Report: show a report when N lines were changed. 0 means 'all'
set report=0

"  Like File Explorer, preview window height is 8
set previewheight=8

"  Always show status line
set ls=2


"  When using list, keep tabs at their full width and display `arrows':
"  (Character 187 is a right double-chevron, and 183 a mid-dot.)
set lcs=
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
execute 'set listchars+=eol:' . nr2char(183)

"  Set the trailing/newline characters to be displayed when wrapping lines
set lcs+=trail:-
set lcs+=nbsp:%
set lcs+=extends:>,precedes:<
set showbreak=>\

"  Check if file is written to elsewhere and ask to reload immediately, not when saving
au CursorHold * checktim


"  Use 4 spaces (I mean it!)
set softtabstop=4
set shiftwidth=4
set tabstop=4

set smarttab
set expandtab
set shiftround

"  Left/Right columns to always keep on the screen
set sidescrolloff=2

"  Top bottom scroll off
set scrolloff=3

"  Min of 4 (default but overrite anyway)
set numberwidth=4

"  Show in title bar
set title

"  Show the cursor position all the time
set ruler

"  Display the current mode and partially-typed commands in the status line:
set showmode
set showcmd


"  Bash tab style completion is awesome
set wildmode=list:longest

"  Try the tab key for now
set wildchar=<TAB>

"  Filenames to not expand to
set wildignore=*~,#*#,*.sw?,*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db,*.class,*.java.html,*.cgi.html,*.html.html,.viminfo,*.pdf

" Suffixes that get lower priority when doing tab completion for filenames.
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc


"  Less verbose status messages
"     f    use "(3 of 5)" instead of "(file 3 of 5)"
"     i    use "[noeol]" instead of "[Incomplete last line]"
"     l    use "999L, 888C" instead of "999 lines, 888 characters"
"     m    use "[+]" instead of "[Modified]"
"     n    use "[New]" instead of "[New File]"
"     r    use "[RO]" instead of "[readonly]"
"     w    use "[w]" instead of "written" for file write message
"          and "[a]" instead of "appended" for ':w >> file' command
"     x    use "[dos]" instead of "[dos format]", "[unix]" instead of
"          "[unix format]" and "[mac]" instead of "[mac format]".
"     a    all of the above abbreviations
"
"     o    overwrite message for writing a file with subsequent message
"          for reading a file (useful for ":wn" or when 'autowrite' on)
"     O    message for reading a file overwrites any previous message.
"          Also for quickfix message (e.g., ":cn").
"     s    don't give "search hit BOTTOM, continuing at TOP" or "search
"          hit TOP, continuing at BOTTOM" messages
"     t    truncate file message at the start if it is too long to fit
"          on the command-line, "<" will appear in the left most column.
"          Ignored in Ex mode.
"     T    truncate other messages in the middle if they are too long to
"          fit on the command line.  "..." will appear in the middle.
"          Ignored in Ex mode.
"     W    don't give "written" or "[w]" when writing a file
"     A    don't give the "ATTENTION" message when an existing swap file
"          is found.
"     I    don't give the intro message when starting Vim |:intro|.
set shortmess=aoOtTI


set splitbelow splitright

"  Don't always keep windows at equal size (for minibufexplorer)
set noequalalways


"  Highlight search
set hlsearch

"  Make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

"  Show the `best match so far' as search strings are typed:
set incsearch

"  Assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

"  Hide mouse on search
set mousehide


"  Don't make it look like there are line breaks where there aren't:
set wrap

"  Wrap at word
set linebreak

"  Have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do by default),
"  and ~ covert case over line breaks; also have the cursor keys wrap in insert mode:
set whichwrap=h,l,~,[,]

"  Normally don't automatically format `text' as it is typed, IE only do this with comments, at 79 characters:
set formatoptions=cq
set textwidth=80

" treat lines starting with a quote mark as comments
set comments+=b:\"


"  Jump to last cursor position when opening a file; don't do it when writing a commit log entry
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction
autocmd BufReadPost * call SetCursorPosition()


"  Do not update screen while executing macros
set lazyredraw
"  Faster text updates
set ttyfast

"  Use tab to indent visual block
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

"  Show dirty leading tabs
set list

"  In block mode, allow us to go past the end of line
set virtualedit=block

"  Make it so mouse and keyboard don't exit select mode
set selectmode=""

"  Fullscreen start for windows
if has("gui_win32")       " NT Windows
        autocmd GUIEnter * :simalt ~x
endif

"  File encoding setup
let $FENCVIEW_TELLENC="fencview"

"  New file browsing config
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1
