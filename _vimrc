set nocompatible
autocmd!
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
syntax on
set background=dark
if has("gui_running")
    if has("gui_win32")
        set guifont=Anonymous_Pro:h12
    else
        set guifont=Anonymous\ Pro\ 12
    endif
    colorscheme molokai
else
    colorscheme vividchalk
endif
set cursorline
behave xterm
set mousemodel=popup
set viminfo=/50,'50,h
set backspace=indent,eol,start
set number
set showmatch
set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
set encoding=utf-8
set nobackup
set history=100
set report=0
set previewheight=8
set ls=2
set lcs=
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
execute 'set listchars+=eol:' . nr2char(183)
set lcs+=trail:-
set lcs+=nbsp:%
set lcs+=extends:>,precedes:<
set showbreak=>\
au CursorHold * checktim
set softtabstop=4
set shiftwidth=4
set tabstop=4
set smarttab
set expandtab
set shiftround
set sidescrolloff=2
set scrolloff=3
set numberwidth=4
set title
set ruler
set showmode
set showcmd
set wildmode=list:longest
set wildchar=<TAB>
set wildignore=*~,#*#,*.sw?,*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db,*.class,*.java.html,*.cgi.html,*.html.html,.viminfo,*.pdf
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set shortmess=aoOtTI
set splitbelow splitright
set noequalalways
set hlsearch
set ignorecase
set smartcase
set incsearch
set gdefault
set mousehide
set wrap
set linebreak
set whichwrap=h,l,~,[,]
set formatoptions=cq
set textwidth=99
set comments+=b:\"
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction
autocmd BufReadPost * call SetCursorPosition()
set lazyredraw
set ttyfast
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
set list
set virtualedit=block
set selectmode=""
if has("gui_win32")       " NT Windows
        autocmd GUIEnter * :simalt ~x
endif
let $FENCVIEW_TELLENC="fencview"
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1
set statusline=
set statusline+=%f\
set statusline+=%h%m%r%w
set statusline+=[%{strlen(&ft)?&ft:'none'},
set statusline+=%{strlen(&fenc)?&fenc:&enc},
set statusline+=%{&fileformat}]
set statusline+=%=
set statusline+=%b,0x%-8B\
set statusline+=%c,%l/
set statusline+=%L\ %P
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=orange
  elseif a:mode == 'r'
    hi statusline guibg=red
  else
    hi statusline guibg=green
  endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=cyan
hi statusline guibg=cyan
au FileType helpfile set nonumber
au FileType helpfile nnoremap <buffer><cr> <c-]>
au FileType helpfile nnoremap <buffer><bs> <c-T>
au BufNewFile,BufRead *.html        setf xhtml
au BufNewFile,BufRead *.pl,*.pm,*.t setf perl
autocmd FileType perl noremap K :!echo <cWORD> <cword> <bar> perl -e '$line = <STDIN>; if ($line =~ /(\w+::\w+)/){exec("perldoc $1")} elsif($line =~ /(\w+)/){exec "perldoc -f $1 <bar><bar> perldoc $1"}'<cr><cr>
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite
autocmd FileType c,cpp,slang        set cindent
autocmd FileType c set formatoptions+=ro
autocmd FileType perl set smartindent
autocmd FileType python set formatoptions-=t
autocmd FileType css set smartindent
autocmd FileType html  set formatoptions+=tl
autocmd FileType xhtml set formatoptions+=tl
let perl_include_pod = 1
let perl_extended_vars = 1
autocmd FileType html        set  omnifunc=htmlcomplete#CompleteTags
autocmd FileType python      set  omnifunc=pythoncomplete#Complete
autocmd FileType javascript  set  omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css         set  omnifunc=csscomplete#CompleteCSS
autocmd FileType xml         set  omnifunc=xmlcomplete#CompleteTags
autocmd FileType php         set  omnifunc=phpcomplete#CompletePHP
autocmd FileType c           set  omnifunc=ccomplete#Complete
function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction
function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif
    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction
function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif
    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction
noremap <silent> <c-s-up> :call <SID>swap_up()<CR>
noremap <silent> <c-s-down> :call <SID>swap_down()<CR>
command! -range=% -register CopyMatches call s:CopyMatches(<line1>, <line2>, '<reg>')
function! s:CopyMatches(line1, line2, reg)
  let reg = empty(a:reg) ? '+' : a:reg
  if reg =~# '[A-Z]'
    let reg = tolower(reg)
  else
    execute 'let @'.reg.' = ""'
  endif
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      execute 'let @'.reg.' .= matchstr(txt, @/, idx) . "\n"'
      let end = matchend(txt, @/, idx)
      let idx = match(txt, @/, end)
    endwhile
  endfor
endfunction
let g:slimv_python = 'C:/Python26/python.exe'
let g:slimv_lisp = '"java -cp C:/clojure/clojure.jar;C:/clojure/clojure-contrib.jar clojure.main"'
let g:lisp_rainbow = 1
map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos='left'
let NERDTreeChDirMode='2'
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
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
let g:SuperTabDefaultCompletionType="context"
let g:xptemplate_brace_complete = ''
let g:xptemplate_key = '<C-Space>'
let g:xptemplate_pum_tab_nav = 1
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
let g:NeoComplCache_MinSyntaxLength = 3
let g:NeoComplCache_ManualCompletionStartLength = 0
let g:NeoComplCache_MinKeywordLength = 3
au FileType perl let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
au FileType vim  let b:delimitMate_smart_quotes = 0
let b:delimitMate_expand_space = 1
let b:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
noremap <Space> <PageDown>
imap jj <Esc>
imap jk <Esc>
nnoremap Q gqap
vnoremap Q gq
noremap Y y$
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>
map <F9> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))<CR>
nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>
nn <F7> :setlocal spell! spell?<CR>
nn <F2> :tab sball<CR>
nnoremap <C-L> :tabnext<CR>
nnoremap <C-H> :tabprevious<CR>
nnoremap <silent><A-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <silent><A-m> m`:s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<CR>``:noh<CR>
nnoremap <silent><A-n> m`:s/\v(<\k+>)(.{-})(<\k*%#\k*>)/\3\2\1/<CR>``:noh<CR>
nn <M-,> k:call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
nn <M-.> :call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^
map <silent> <C-N> :silent noh<CR>
inoremap <S-CR> <Esc>
nnoremap <S-space> i <esc>la <esc>h
noremap  <C-S-space> lBi <esc>Ea <esc>B
noremap     <S-Insert> "+gP
vnoremap    <S-Insert> "+gP
cmap        <S-Insert> <C-R>+
vnoremap <C-C>      "+y
vnoremap <C-Insert> "+y
noremap <C-T> :tabnew<CR>
nmap <C-F4> :bd<CR>
noremap \qa :qa!<CR>
nnoremap \tn :set number!<Bar> set number?<CR>
map \c :let @/ = ""<CR>
nnoremap \r :e!<CR>
nmap \ttt :execute "normal a" . strftime("%x %X (%Z)")<Esc>
imap \ttt <Esc>:execute "normal a" . strftime("%x %X (%Z)")<Esc>a
:noremap \u :sort u<CR>:g/^$/d<CR>
:noremap \= :Align =><CR>
:noremap \m :CopyMatches<CR>:tabnew<CR>"+p<CR>:sort u<CR>:g/^$/d<CR>ggVG"+y
:noremap \fd :%s/\v(\d{1,2})\/(\d{1,2})\/(\d{4})/\3\/\1\/\2/<CR>
:noremap \dn :tabnew<CR>:diffthis<CR>:vne<CR>:diffthis<CR>
:noremap \dt :diffthis<CR>:vne<CR>:diffthis<CR>
:noremap ,du :diffupdate<CR>
nnoremap \tp :set invpaste paste?<CR>
nnoremap \tl :set invlist!<CR>
nnoremap \ca ggVG"+y
nmap \s :source $MYVIMRC<CR>
nmap \v :tabnew $MYVIMRC<CR>
nmap \snip :tabnew $HOME\\vimfiles\\snippets\\
nmap \mod  :tabnew C:\\Work\\irm_vm\\Modules\\trunk\\IRM\\
nmap \script  :tabnew C:\\Work\\irm_vm\\Scripts\\trunk\\
noremap \sa :SessionSaveAs scratcha<CR>
noremap \sb :SessionSaveAs scratchb<CR>
noremap \qs :SessionSaveAs quitscrach<CR>:qa!<CR>
:noremap ,h :RN<CR>
:noremap ,v :vne<CR>
:noremap ,q  qqqqq
:noremap ,m :CopyMatches<CR>
:noremap ,u :sort u<CR>:g/^$/d<CR>
:noremap ,a  qaq
:noremap ,t :%s/\..*//<CR>
:noremap ,i :%s/\v^(.*)$/    '\1',/<CR>G$xo)<Esc>ggO(<Esc>:silent noh<CR>
noremap ,sa :SessionOpen scratcha<CR>
noremap ,sb :SessionOpen scratchb<CR>
noremap ,qs :SessionOpen quitscrach<CR>
noremap ,cab :tabdo :bd!<CR>
abb teh the
abb fo of
abb taht that
abb wehn when
inoremap qw/<SPACE>     qw/<SPACE><SPACE>/<Left><Left>
inoremap qw/;     qw/<SPACE><SPACE>/;<Left><Left><Left>
inoremap qw/<CR> qw/<CR>/;<Esc>O<Tab>
inoremap qr{<CR> qr{<CR>}xms;<Esc>O<Tab>
