set nocompatible
autocmd!
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
syntax on
set background=dark
if has("gui_running")
    if has("gui_win32")
        set guifont=DejaVu_Sans_Mono:h11
        autocmd GUIEnter * :simalt ~x
    else
        set guifont=DejaVu\ Sans\ Mono\ 11
    endif
    colorscheme xoria256
    set antialias
else
    colorscheme wombat256
endif
set cursorline
set guioptions-=T
set guioptions-=m
set showtabline=2
augroup vimrcExEOLWS
    au!
    highlight EOLWS  ctermbg=darkgreen guibg=darkgreen
    highlight PEP8WS ctermbg=darkgreen guibg=darkgreen
    autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/ containedin=ALL
    autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/ containedin=ALL
    autocmd FileType python syn match PEP8WS excludenl /^\t\+/ containedin=ALL
augroup END
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
set noswapfile
set history=100
set report=0
set previewheight=8
set ls=2
set lcs=
execute 'set listchars+=tab:'  . nr2char(187) . nr2char(183)
execute 'set listchars+=eol:'  . nr2char(739)
execute 'set listchars+=nbsp:' . nr2char(9251)
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
set textwidth=100
set comments+=b:\"
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction
autocmd BufReadPost * call SetCursorPosition()
set ttyfast
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
set list
set virtualedit=block
set selectmode=""
let $FENCVIEW_TELLENC="fencview"
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1
set rnu
set wak=no
set statusline=
set statusline+=%f/
set statusline+=%h%m%r%w
set statusline+=[%{strlen(&ft)?&ft:'none'},
set statusline+=%{strlen(&fenc)?&fenc:&enc},
set statusline+=%{&fileformat}]
set statusline+=%=
set statusline+=%b,0x%-8B
set statusline+=%c,%l/
set statusline+=%L\ %P
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=#9b601a
  elseif a:mode == 'r'
    hi statusline guibg=#9b3535
  elseif a:mode == 'v'
    hi statusline guibg=#a7a863
  else
    hi statusline guibg=#727272
endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * call InsertStatuslineColor('n')
au FileType helpfile set nonumber
au FileType helpfile nnoremap <buffer><cr> <c-]>
au FileType helpfile nnoremap <buffer><bs> <c-T>
au BufNewFile,BufRead *.html        setf xhtml
au BufNewFile,BufRead *.pl,*.pm,*.t setf perl
autocmd FileType perl noremap K :!echo <cWORD> <cword> <bar> perl -e '$line = <STDIN>; if ($line =~ /(\w+::\w+)/){exec("perldoc $1")} elsif($line =~ /(\w+)/){exec "perldoc -f $1 <bar><bar> perldoc $1"}'<cr><cr>
au BufRead * set rnu
autocmd FileType perl set makeprg=perl\ -c\ -T\ \"%\"\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite
autocmd FileType c,cpp,slang        set cindent
autocmd FileType c set formatoptions+=ro
autocmd FileType python set formatoptions-=t
autocmd FileType css set smartindent
autocmd FileType html  set formatoptions+=tl
autocmd FileType xhtml set formatoptions+=tl
let perl_include_pod = 1
let perl_extended_vars = 1
autocmd FileType php  setlocal  omnifunc=phpcomplete#CompletePHP
autocmd FileType c    setlocal  omnifunc=ccomplete#Complete
autocmd FileType css            setlocal  omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown  setlocal  omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript     setlocal  omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python         setlocal  omnifunc=pythoncomplete#Complete
autocmd FileType xml            setlocal  omnifunc=xmlcomplete#CompleteTags
function! g:ToggleNuMode()
    if(&rnu == 1)
        set nu
    else
        set rnu
    endif
endfunc
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
noremap  <silent> <C-S-UP>   :call <SID>swap_up()<CR>
noremap  <silent> <C-S-DOWN> :call <SID>swap_down()<CR>
noremap  <silent> <A-k>      :call <SID>swap_up()<CR>
noremap  <silent> <A-j>      :call <SID>swap_down()<CR>
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
function! s:StripTrailingWhitespaces()
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
command! -range=% -register StripTrailingWhitespaces call s:StripTrailingWhitespaces()
map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos    = 'left'
let NERDTreeChDirMode = '2'
let NERDTreeIgnore    = ['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let g:vimclojure#ParenRainbow        = 1
let g:vimclojure#DynamicHighlighting = 1
let g:vimclojure#WantNailgun = 1
let g:vimclojure#SplitPos = "bottom"
let g:vimclojure#SplitSize = 13
if !exists('g:FuzzyFinderOptions')
    let g:FuzzyFinderOptions                       = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
    let g:FuzzyFinderOptions.File.excluded_path    = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.{1,2}[/\\]$)|\.pyo$|\.pyc$|\.svn[/\\]$'
    let g:FuzzyFinderOptions.Base.key_open_Tabpage = '<Space>'
endif
let g:fuzzy_matching_limit = 60
let g:fuzzy_ceiling        = 50000
let g:fuzzy_ignore         = "*.log;*.pyc;*.svn;"
map <silent> \f :FufFile<CR>
map <silent> \b :FufBuffer<CR>
let g:xptemplate_brace_complete = ''
let g:xptemplate_key = '<C-Space>'
let g:xptemplate_pum_tab_nav = 1
let g:xptemplate_vars="$author=Adam Lesperance"
let g:xptemplate_vars="$email=lespea@gmail.com"
au FileType vim  let b:delimitMate_quotes = " ' ` *"
let g:delimitMate_matchpairs = "(:),[:],{:}"
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_balance_matchpairs = 1
vmap <leader>i  <plug>blockinsert-i
vmap <leader>a  <plug>blockinsert-a
nmap <leader>i  <plug>blockinsert-i
nmap <leader>a  <plug>blockinsert-a
vmap <leader>[]  <plug>blockinsert-b
vmap <leader>q[] <plug>blockinsert-qb
nmap <leader>[]  <plug>blockinsert-b
nmap <leader>q[] <plug>blockinsert-qb
let g:indent_guides_enable_on_vim_startup = 1
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 0
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
let g:EasyMotion_leader_key = ','
cmap w!! w !sudo tee % >/dev/null
vnoremap ; :
noremap <Space> <PageDown>
inoremap jk <Esc>
nnoremap j gj
nnoremap k gk
nnoremap Q gqap
vnoremap Q gq
noremap Y y$
nnoremap <F1> :help<Space>
vnoremap <F1> <C-C><F1>
noremap  <F1> <C-C><F1>
noremap! <F1> <C-C><F1>
noremap <F9> :StripTrailingWhitespaces<CR>
noremap <F10> :set expandtab<CR>:retab<CR>
nnoremap <F4> \tp
inoremap <F4> <C-O>\tp
set pastetoggle=<F4>
nnoremap <F5> :GundoToggle<CR>
noremap <F7> :setlocal spell! spell?<CR>
noremap <F2> :tab sball<CR>
noremap <F3> :Rearrangetabsbypath 1<CR>
nnoremap <C-L> :tabnext<CR>
nnoremap <C-H> :tabprevious<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <silent><A-.> m`:s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<CR>``:noh<CR>
nnoremap <silent><A-,> m`:s/\v(<\k+>)(.{-})(<\k*%#\k*>)/\3\2\1/<CR>``:noh<CR>
noremap <silent><A-n> k:call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
noremap <silent><A-m> :call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^
noremap <silent><C-N> :silent noh<CR>
nnoremap <S-space> i <esc>la <esc>h
noremap  <S-C-space> m`lBi <esc>Ea <esc>``l
noremap     <S-Insert>  "+gP
noremap     <C-S>       "+gP
vnoremap    <S-Insert>  "+gP
cnoremap    <S-Insert>  <C-R>+
cnoremap    <C-S>       <C-R>+
vnoremap <C-C>      "+y
vnoremap <C-Insert> "+y
noremap <C-T> :tabnew<CR>
nnoremap <C-F4> :bd<CR>
noremap \qa :qa!<CR>
nnoremap \tn :set number!<Bar> set number?<CR>
noremap \c :let @/ = ""<CR>
nnoremap \r :e!<CR>
nnoremap \ttt :execute "normal a" . strftime("%x %X (%Z)")<Esc>
inoremap \ttt <Esc>:execute "normal a" . strftime("%x %X (%Z)")<Esc>a
noremap \u :sort u<CR>:g/^$/d<CR>
noremap \= :Align =><CR>
noremap \m :CopyMatches<CR>:tabnew<CR>"+p<CR>:sort u<CR>:g/^$/d<CR>:1,$y+<CR>
noremap \fd :silent! 1,$!perl -nMDateTime::Format::DateParse -E"BEGIN{sub fd{my $line = shift;chomp $line;my $dt = DateTime::Format::DateParse->parse_datetime($line, 'America/Chicago');$dt ? ($dt->set_time_zone('America/Chicago') and $dt->strftime('\%Y-\%m-\%d \%H:\%M:\%S')) : $line}; use Memoize; memoize 'fd'}say fd($_)"<CR>:norm \ca<CR>
noremap \fc :new<CR>"+p"+:1,$y+<CR>:bd!<CR>
noremap \dbs :%s/\./\t/<CR>:%s/^\([^\t]\+\)\ze\t[^\t]\+$/\1\t\1<CR>
noremap \dn :tabnew<CR>:diffthis<CR>:vne<CR>:diffthis<CR>
noremap \dt :diffthis<CR>:vne<CR>:diffthis<CR>
noremap ,du :diffupdate<CR>
nnoremap \tp :set invpaste paste?<CR>
nnoremap \tl :set invlist!<CR>
nnoremap \ca :1,$y+<CR>
nnoremap \s :source $MYVIMRC<CR>
nnoremap \v :tabnew $MYVIMRC<CR>
noremap \sa :SessionSaveAs scratcha<CR>
noremap \sb :SessionSaveAs scratchb<CR>
noremap \qs :SessionSaveAs quitscrach<CR>:qa!<CR>
noremap \fb mcHmt:g/^ *{ *$/norm kJ:s/ *{ *$/ {/<CR>:silent :noh<CR>'tzt`c
noremap ,h :call g:ToggleNuMode()<CR>
noremap ,v :vne<CR>
noremap ,q  qqqqq
noremap ,m :CopyMatches<CR>
noremap ,u :sort u<CR>:g/^$/d<CR>
noremap ,a  qaq
noremap ,t :%s/\(\<[a-zA-Z0-9_-]*[a-zA-Z][a-zA-Z0-9_-]*\)\.[a-zA-Z0-9_.-]*\>/\1/<CR>:silent noh<CR>
noremap ,i :g/^$/d<CR>:%s/\v^(.*)$/   ,'\1'/<CR>:1s/   ,/(\r    <CR>:$s/$/\r)<CR>:silent noh<CR>"+:1,$y+<CR>
noremap ,sa :SessionOpen scratcha<CR>
noremap ,sb :SessionOpen scratchb<CR>
noremap ,qs :SessionOpen quitscrach<CR>
noremap ,cab :tab sball<CR>:tabdo :bd!<CR>:tab sball<CR>:tabdo :bd!<CR>
noremap ,cd :cd %:p:h<CR>
noremap ,sep :g/^\(\S\+\).\+\n\1\@!/s/$/\r<CR>:silent noh<CR>
noremap ,dupe :sort<CR>:g/^\(.\+\)\n\1\@!/d<CR>yyp:%s/^\(.\+\)\n\1\+/\1/<CR>:g/^$/d<CR>:silent noh<CR>
noremap ,conf :tabnew $HOME/vimconfigs/
noremap \fa :let b:l=matchend(getline('.'), '^ *')<CR>0f(a<CR><ESC>$F)i<CR><ESC>:s/^ */\=repeat(' ', b:l)<CR>k:s/,\zs */\r<CR>vibkV:s/^ */\=repeat(' ', b:l+4)<CR>:silent :noh<CR>
:noremap \md gg/^"*date<CR>"ayy:silent bufdo /^"*date/1,$y A<CR>:tabnew<CR>V"ap:g/^[^,]*,[^,]*$/s/,/,CISCO,Raw,/<CR>:%s/,/\t/e\|%s/^"*\(\w\+-\)\%(\d\d\)*\(\d\d\)"*\ze\t/\120\2/e\|%s/^"*\(\d\d\)-\(\w\+\)"*\ze\t/\2-20\1/e<CR>:2,$sort<CR>:nohlsearch<CR>:1,$y+<CR>
:nmap <silent> <C-F11> :if &guioptions=~'m' \| set guioptions-=m \| else \| set guioptions+=m \| endif<cr>
abb teh the
abb fo of
abb taht that
abb wehn when
inoremap qw/<SPACE>     qw/<SPACE><SPACE>/<Left><Left>
inoremap qw/;     qw/<SPACE><SPACE>/;<Left><Left><Left>
inoremap qw/<CR> qw/<CR>/;<Esc>O<Tab>
inoremap qr{<CR> qr{<CR>}xms;<Esc>O<Tab>
