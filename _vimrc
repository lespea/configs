" -----------------------------------------------------------------------------
" | VIM Settings                                                              |
" -----------------------------------------------------------------------------
set nocompatible

" first clear any existing autocommands:
autocmd!

behave xterm

" General *********************************************************************
" save last 50 search history items, last 50 edit marks, don't remember search
" highlight
set viminfo=/50,'50,h

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=      "left/right separator
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\      " current char
set statusline+=%c,%l/ "cursor column/total lines
set statusline+=%L\ %P "total lines/percentage in file

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=orange
  elseif a:mode == 'r'
    hi statusline guibg=cyan
  else
    hi statusline guibg=red
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=blue

" default the statusline to green when entering Vim
hi statusline guibg=blue



"make backspace work
set backspace=indent,eol,start
" Show line numbers
set number
" Show matching brackets.
set showmatch
" have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
" This being the 21st century, I use Unicode
set encoding=utf-8
" Don't keep a backup file
set nobackup
" keep 100 lines of command line history
set history=100
" Automatically save before commands like :next and :make
set autowrite
" report: show a report when N lines were changed. 0 means 'all'
set report=0
" runtimepath: list of dirs to search for runtime files
set runtimepath+=~/.vim
" Like File Explorer, preview window height is 8
set previewheight=8
" always show status line
set ls=2
"
" when using list, keep tabs at their full width and display `arrows':
" (Character 187 is a right double-chevron, and 183 a mid-dot.)
set lcs=
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
execute 'set listchars+=eol:' . nr2char(183)
set lcs+=trail:-
set lcs+=nbsp:%
set lcs+=extends:>,precedes:<
:set showbreak=>\ 

"check if file is written to elsewhere and ask to reload immediately, not when saving
au CursorHold * checktim

" Tabs **********************************************************************
function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set noexpandtab
endfunction

function! Tabstyle_spaces()
  " Use 4 spaces
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set expandtab
endfunction

" Tabs should be converted to a group of 4 spaces.
" indent length with < >
set shiftwidth=4
set tabstop=4
"Insert spaces for tabs
set smarttab
set expandtab
set shiftround

" Scrollbars/Status ***********************************************************
set sidescrolloff=2
" top bottom scroll off
set scrolloff=2
" set numberwidth=4
" show in title bar
set title
" show the cursor position all the time
set ruler
" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" Bash tab style completion is awesome
set wildmode=longest,list
" wildchar  the char used for "expansion" on the command line default value is
" "<C-E>" but I prefer the tab key:
" set wildchar=<TAB>



set wildignore=*~,#*#,*.sw?,*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db,*.class,*.java.html,*.cgi.html,*.html.html,.viminfo,*.pdf
" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages!
" set shortmess=atIAr
set shortmess=flnrxoOItTA

" Windows *********************************************************************
set splitbelow splitright
" don't always keep windows at equal size (for minibufexplorer)
set noequalalways

"Vertical split then hop to new buffer
":noremap ,v :vsp^M^W^W<cr>
":noremap ,h :split^M^W^W<cr>

" Cursor highlights ***********************************************************
set cursorline
"set cursorcolumn

" Searching *******************************************************************
" highlight search
set hlsearch
" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase
" show the `best match so far' as search strings are typed:
set incsearch
" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault
" hide mouse on search
set mousehide

" Colors **********************************************************************
syntax on
set background=dark
if has("gui_running")
    set guifont=Anonymous_Pro:h12
    colorscheme herald
else
    colorscheme candycode
endif

if has("gui_win32")       " NT Windows
        autocmd GUIEnter * :simalt ~x
endif

" Omni Completion *************************************************************
" set ofu=syntaxcomplete#Complete
autocmd FileType html        set  omnifunc=htmlcomplete#CompleteTags
autocmd FileType python      set  omnifunc=pythoncomplete#Complete
autocmd FileType javascript  set  omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css         set  omnifunc=csscomplete#CompleteCSS
autocmd FileType xml         set  omnifunc=xmlcomplete#CompleteTags
autocmd FileType php         set  omnifunc=phpcomplete#CompletePHP
autocmd FileType c           set  omnifunc=ccomplete#Complete

" Line Wrapping ***************************************************************
" don't make it look like there are line breaks where there aren't:
set wrap
" Wrap at word
set linebreak

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions=cq
set textwidth=79

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!), and colons as well so that reformatting usenet messages from
" `Tin' users works OK:
set comments+=b:\"
set comments+=n::

" File Stuff ******************************************************************
" To show current filetype use: set filetype
filetype plugin indent on

" Filetypes (au = autocmd)
au FileType helpfile set nonumber      " no line numbers when viewing help
au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

" we couldn't care less about html
au BufNewFile,BufRead *.html        setf xhtml
"Laszlo
au BufNewFile,BufRead *.lzx         setf lzx
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc         setf php
au BufNewFile,BufRead *.pl,*.pm,*.t setf perl

" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang        set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

autocmd FileType python set formatoptions-=t

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction



" Redraw *********************************************************************
" lazyredraw: do not update screen while executing macros
"set lazyredraw
" ttyfast: are we using a fast terminal? Let's try it for a while.
set ttyfast
" ttyscroll: redraw instead of scrolling
"set ttyscroll=0

" Aliases        *************************************************************
" Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
imap jj <Esc>

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
" noremap - <PageUp>

" [<Space> by default is like l, <BkSpc> like h, and - like k.]
" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

"trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
"map <Esc>[Z <s-tab>
"ounmap <Esc>[Z

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]
nnoremap <C-L> :tabnext<CR>
nnoremap <C-H> :tabprevious<CR>

" swap windows
nmap , <C-w><C-w>

"move around windows with ctrl key!
"map <C-H> <C-W>h
"map <C-J> <C-W>j
"map <C-K> <C-W>k
"map <C-L> <C-W>l

" this might replace all of this http://www.vim.org/scripts/script.php?script_id=1643
" Remap TAB to keyword completion
"function! InsertTabWrapper(direction)
"  let col = col('.') - 1
"  if !col || strpart(getline('.'), col-1, col) =~ '\s'
"    return "\<tab>"
"  elseif "forward" == a:direction
"    return "\<c-n>"
"  elseif "backward" == a:direction
"    return "\<c-d>"
"  else
"    return "\<c-x>\<c-k>"
"  endif
"endfunction

"inoremap <Tab> <c-r>=InsertTabWrapper ("forward")<CR>
"inoremap <S-Tab> <c-r>=InsertTabWrapper ("backward")<CR>
"inoremap <C-Tab> <c-r>=InsertTabWrapper ("startkey")<CR>
"nmap <Tab> >>
"nmap <S-Tab> <<

" toggle tab completion
"function! ToggleTabCompletion()
"  if mapcheck("\<tab>", "i") != ""
"    iunmap <tab>
"    iunmap <s-tab>
"    iunmap <c-tab>
"    echo "tab completion off"
"  else
"    imap <tab> <c-n>
"    imap <s-tab> <c-p>
"    imap <c-tab> <c-x><c-l>
"    echo "tab completion on"
"  endif
"endfunction
"map <Leader>tc :call ToggleTabCompletion()<CR>

" tell complete to look in the dictionary
set complete-=k complete+=k

" load the dictionary according to syntax
" au BufReadPost * if exists("b:current_syntax")
" au BufReadPost * let &dictionary = substitute("C:\\vim\\vimfiles\\dict\\FT.dict", "FT", b:current_syntax, "")
" au BufReadPost * endif

" inoremap <Tab> <C-T>
" inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Above/below adding and creating
nnoremap <silent><A-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" toggle paste on/off
nnoremap \tp :set invpaste paste?<CR>

"toggle list on/off and report the change (start with list on):
nnoremap \tl :set invlist list?<CR>
nnoremap \ca ggVG"+y
set list

"toggle highlighting of search matches, and report the change:
nnoremap \th :set invhls hls?<CR>

"toggle numbers
nnoremap \tn :set number!<Bar> set number?<CR>

"toggle wrap and easy movement keys while in wrap mode
noremap <silent> <Leader>tw :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> k
    silent! nunmap <buffer> j
    silent! nunmap <buffer> 0
    silent! nunmap <buffer> $
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" toggle showbreak for long lines
function! TYShowBreak()
  if &showbreak == ''
    set showbreak=>
    echo "show break on"
  else
    set showbreak=
    echo "show break off"
  endif
endfunction
nmap  <expr> \tb  TYShowBreak()
\tb

"clear the fucking search buffer, not just remove the highlight
map \c :let @/ = ""<CR>

" Revert the current buffer
nnoremap \r :e!<CR>

"Easy edit of vimrc
nmap \s :source $MYVIMRC<CR>
nmap \v :tabnew $MYVIMRC<CR>
nmap \snip :tabnew $HOME\\vimfiles\\snippets\\
nmap \mod  :tabnew C:\\Work\\irm_vm\\Modules\\trunk\\IRM\\
nmap \script  :tabnew C:\\Work\\irm_vm\\Scripts\\trunk\\
nmap <C-T> :tabnew<CR>
nmap <C-F4> :bd<CR>

"show indent stuff
nmap \I :verbose set ai? cin? cink? cino? si? inde? indk? formatoptions?<CR>

"replace all tabs with 4 spaces
map \ft :%s/	/    /g<CR>

"OSX only: Open a web-browser with the URL in the current line
"function! HandleURI()
"  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
"  echo s:uri
"  if s:uri != ""
"   exec "!open \"" . s:uri . "\""
"  else
"   echo "No URI found in line."
"  endif
"endfunction
"map <Leader>o :call HandleURI()<CR>
" Custom text inserts *********************************************************
"insert THE time!
nmap <Leader>ttt :execute "normal i" . strftime("%x %X (%Z) ")<Esc>
imap <Leader>ttt <Esc>:execute "normal i" . strftime("%x %X (%Z) ")<Esc>i

" -----------------------------------------------------------------------------
" | Pluggins                                                                  |
" -----------------------------------------------------------------------------
""Taglist
"map \a :TlistToggle<CR>
"" Jump to taglist window on open.
"let Tlist_GainFocus_On_ToggleOpen = 1
"let Tlist_Close_OnSelect=1
"" if you are the last window, kill yourself
"let Tlist_Exist_OnlyWindow = 1
"" sort by order or name
"let Tlist_Sort_Type = "order"
"" do not show prototypes and not tags in the taglist window.
"let Tlist_Display_Prototype = 0
"" Remove extra information and blank lines from the taglist window.
"let Tlist_Compart_Format = 1
"" Show tag scope next to the tag name.
"let Tlist_Display_Tag_Scope = 1
"let Tlist_WinWidth = 40
"" Show only current file
"let Tlist_Show_One_File = 1

"NERDTree
map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos='right'
let NERDTreeChDirMode='2'
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']

"FuzzyFinder
"Seriously FF, setting up your options sucks
if !exists('g:FuzzyFinderOptions')
    let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
    let g:FuzzyFinderOptions.File.excluded_path = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.{1,2}[/\\]$)|\.pyo$|\.pyc$|\.svn[/\\]$'
    let g:FuzzyFinderOptions.Base.key_open_Tabpage = '<Space>'
endif
let g:fuzzy_matching_limit = 60
let g:fuzzy_ceiling = 50000
let g:fuzzy_ignore = "*.log;*.pyc;*.svn;"
map <silent> \f :FufFile<CR>
map <silent> \b :FufBuffer<CR>

"newrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1





vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <S-Insert> "+gP
vnoremap <S-Insert> "+gP
cmap <S-Insert> <C-R>+

let $FENCVIEW_TELLENC="fencview"


nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>


" check perl code with :make
" autocmd FileType perl set makeprg=perl\ -c\ %\ $*
" autocmd FileType perl set errorformat=%f:%l:%m
" autocmd FileType perl set autowrite

" my perl includes pod
let perl_include_pod = 1

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1



nn <F7> :setlocal spell! spell?<CR>
nn <F2> :tab sball<CR>


" Turn off highlighted search
map <silent> <C-N> :silent noh<CR>

"  Don't over-ride the trailing ')'s
inoremap        (<SPACE>  ()<Left>
inoremap        ((  ()<Left>
inoremap        (;        ();<Left><Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

inoremap        {<SPACE>  {}<Left>
inoremap        {{  {}<Left>
inoremap        {;        {};<Left><Left>
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

inoremap        [<SPACE>  []<Left>
inoremap        [[  []<Left>
inoremap        [;        [];<Left><Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"

inoremap qw/<SPACE>     qw/<SPACE><SPACE>/<Left><Left>
inoremap qw/;     qw/<SPACE><SPACE>/;<Left><Left><Left>
inoremap qw/<CR> qw/<CR>/;<Esc>O<Tab>

inoremap qr{<CR> qr{<CR>}xms;<Esc>O<Tab>

inoremap {<CR> {<CR>}<Esc>O
inoremap (<CR> (<CR>);<Esc>O
inoremap /<CR> /<CR>/;<Esc>O
nnoremap <silent><A-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>



let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs  = 1
let g:miniBufExplModSelTarget       = 1
let g:miniBufExplorerMoreThanOne    = 1
let g:miniBufExplUseSingleClick     = 1

abb teh the

map <F9> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))<CR>

" Move up or down with same indent level
nn <M-,> k:call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
nn <M-.> :call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^


"map! <S-space> <esc>
inoremap <S-CR> <Esc>
nnoremap <C-space> i <esc>la <esc>h
nmap <C-S-space> lBi <esc>Ea <esc>B

set virtualedit=block

"make it so mouse and keyboard don't exit select mode."
"this makes it so we can select with the mouse and then act on that block."
set selectmode=""

" Fullscreen start
if has("gui_win32")       " NT Windows
        autocmd GUIEnter * :simalt ~x
endif




iabbrev accesories accessories
iabbrev accomodate accommodate
iabbrev acheive achieve
iabbrev acheiving achieving
iabbrev acn can
iabbrev acommodate accommodate
iabbrev acomodate accommodate
iabbrev acommodated accommodated
iabbrev acomodated accommodated
iabbrev adn and
iabbrev agian again
iabbrev ahppen happen
iabbrev ahve have
iabbrev ahve have
iabbrev allready already
iabbrev almsot almost
iabbrev alos also
iabbrev alot a lot
iabbrev alreayd already
iabbrev alwasy always
iabbrev amke make
iabbrev anbd and
iabbrev andthe and the
iabbrev appeares appears
iabbrev aplyed applied
iabbrev artical article
iabbrev aslo also
iabbrev audeince audience
iabbrev audiance audience
iabbrev awya away
iabbrev bakc back
iabbrev balence balance
iabbrev baout about
iabbrev bcak back
iabbrev beacuse because
iabbrev becasue because
iabbrev becomeing becoming
iabbrev becuase because
iabbrev becuse because
iabbrev befoer before
iabbrev begining beginning
iabbrev beleive believe
iabbrev bianry binary
iabbrev bianries binaries
iabbrev boxs boxes
iabbrev bve be
iabbrev changeing changing
iabbrev charachter character
iabbrev charcter character
iabbrev charcters characters
iabbrev charecter character
iabbrev charector character
iabbrev cheif chief
iabbrev circut circuit
iabbrev claer clear
iabbrev claerly clearly
iabbrev cna can
iabbrev colection collection
iabbrev comany company
iabbrev comapny company
iabbrev comittee committee
iabbrev commitee committee
iabbrev committe committee
iabbrev committy committee
iabbrev compair compare
iabbrev compleated completed
iabbrev completly completely
iabbrev comunicate communicate
iabbrev comunity community
iabbrev conected connected
iabbrev cotten cotton
iabbrev coudl could
iabbrev cpoy copy
iabbrev cxan can
iabbrev danceing dancing
iabbrev definately definitely
iabbrev develope develop
iabbrev developement development
iabbrev differant different
iabbrev differnt different
iabbrev diffrent different
iabbrev disatisfied dissatisfied
iabbrev doese does
iabbrev doign doing
iabbrev doller dollars
iabbrev donig doing
iabbrev driveing driving
iabbrev drnik drink
iabbrev ehr her
iabbrev embarass embarrass
iabbrev equippment equipment
iabbrev esle else
iabbrev excitment excitement
iabbrev exmaple example
iabbrev exmaples examples
iabbrev eyt yet
iabbrev familar familiar
iabbrev feild field
iabbrev fianlly finally
iabbrev fidn find
iabbrev firts first
iabbrev follwo follow
iabbrev follwoing following
iabbrev foriegn foreign
iabbrev fro for
iabbrev foudn found
iabbrev foward forward
iabbrev freind friend
iabbrev frmo from
iabbrev fwe few
iabbrev gerat great
iabbrev geting getting
iabbrev giveing giving
iabbrev goign going
iabbrev gonig going
iabbrev govenment government
iabbrev gruop group
iabbrev grwo grow
iabbrev haev have
iabbrev happend happened
iabbrev haveing having
iabbrev hda had
iabbrev helpfull helpful
iabbrev herat heart
iabbrev hge he
iabbrev hismelf himself
iabbrev hsa has
iabbrev hsi his
iabbrev hte the
iabbrev htere there
iabbrev htey they
iabbrev hting thing
iabbrev htink think
iabbrev htis this
iabbrev hvae have
iabbrev hvaing having
iabbrev idae idea
iabbrev idaes ideas
iabbrev ihs his
iabbrev immediatly immediately
iabbrev indecate indicate
iabbrev insted intead
iabbrev inthe in the
iabbrev iwll will
iabbrev iwth with
iabbrev jsut just
iabbrev knwo know
iabbrev knwos knows
iabbrev konw know
iabbrev konws knows
iabbrev levle level
iabbrev libary library
iabbrev librarry library
iabbrev librery library
iabbrev librarry library
iabbrev liek like
iabbrev liekd liked
iabbrev liev live
iabbrev likly likely
iabbrev littel little
iabbrev liuke like
iabbrev liveing living
iabbrev loev love
iabbrev lonly lonely
iabbrev makeing making
iabbrev mkae make
iabbrev mkaes makes
iabbrev mkaing making
iabbrev moeny money
iabbrev mroe more
iabbrev mysefl myself
iabbrev myu my
iabbrev neccessary necessary
iabbrev necesary necessary
iabbrev nkow know
iabbrev nwe new
iabbrev nwo now
iabbrev ocasion occasion
iabbrev occassion occasion
iabbrev occurence occurrence
iabbrev occurrance occurrence
iabbrev ocur occur
iabbrev oging going
iabbrev ohter other
iabbrev omre more
iabbrev onyl only
iabbrev optoin option
iabbrev optoins options
iabbrev opperation operation
iabbrev orginized organized
iabbrev otehr other
iabbrev otu out
iabbrev owrk work
iabbrev peopel people
iabbrev perhasp perhaps
iabbrev perhpas perhaps
iabbrev pleasent pleasant
iabbrev poeple people
iabbrev porblem problem
iabbrev preceed precede
iabbrev preceeded preceded
iabbrev probelm problem
iabbrev protoge protege
iabbrev puting putting
iabbrev pwoer power
iabbrev quater quarter
iabbrev questoin question
iabbrev reccomend recommend
iabbrev reccommend recommend
iabbrev receieve receive
iabbrev recieve receive
iabbrev recieved received
iabbrev recomend recommend
iabbrev reconize recognize
iabbrev recrod record
iabbrev religous religious
iabbrev rwite write
iabbrev rythm rhythm
"iabbrev seh she
iabbrev selectoin selection
iabbrev sentance sentence
iabbrev seperate separate
iabbrev shineing shining
iabbrev shiped shipped
iabbrev shoudl should
iabbrev similiar similar
iabbrev smae same
iabbrev smoe some
iabbrev soem some
iabbrev sohw show
iabbrev soudn sound
iabbrev soudns sounds
iabbrev statment statement
iabbrev stnad stand
iabbrev stopry story
iabbrev stoyr story
iabbrev stpo stop
iabbrev strentgh strength
iabbrev struggel struggle
iabbrev sucess success
iabbrev swiming swimming
iabbrev tahn than
iabbrev taht that
iabbrev talekd talked
iabbrev tath that
iabbrev teh the
iabbrev tehy they
iabbrev tghe the
iabbrev thansk thanks
iabbrev themselfs themselves
iabbrev theri their
iabbrev thgat that
iabbrev thge the
iabbrev thier their
iabbrev thme them
iabbrev thna than
iabbrev thne then
iabbrev thnig thing
iabbrev thnigs things
iabbrev thsi this
iabbrev thsoe those
iabbrev thta that
iabbrev tihs this
iabbrev timne time
iabbrev tje the
iabbrev tjhe the
iabbrev tkae take
iabbrev tkaes takes
iabbrev tkaing taking
iabbrev tlaking talking
iabbrev todya today
iabbrev tongiht tonight
iabbrev tonihgt tonight
iabbrev towrad toward
iabbrev tpyo typo
iabbrev truely truly
iabbrev tyhat that
iabbrev tyhe the
iabbrev useing using
iabbrev vacumme vacuum
iabbrev veyr very
iabbrev vrey very
iabbrev waht what
iabbrev watn want
iabbrev wehn when
iabbrev whcih which
iabbrev whic which
iabbrev whihc which
iabbrev whta what
iabbrev wief wife
iabbrev wierd weird
iabbrev wihch which
iabbrev wiht with
iabbrev windoes windows
iabbrev withe with
iabbrev wiull will
iabbrev wnat want
iabbrev wnated wanted
iabbrev wnats wants
iabbrev woh who
iabbrev wohle whole
iabbrev wokr work
iabbrev woudl would
iabbrev wriet write
iabbrev wrod word
iabbrev wroking working
iabbrev wtih with
iabbrev wya way
iabbrev yera year
iabbrev yeras years
iabbrev ytou you
iabbrev yuo you
iabbrev yuor your

" Days of weeks
iabbrev monday Monday
iabbrev tuesday Tuesday
iabbrev wednesday Wednesday
iabbrev thursday Thursday
iabbrev friday Friday
iabbrev saturday Saturday
iabbrev sunday Sunday
