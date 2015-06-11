set nocompatible
autocmd!
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
set encoding=utf-8
let $VIMHOME=fnamemodify(resolve(expand('<sfile>:p')), ':h')
syntax on
set synmaxcol=250
set background=dark
let g:Powerline_symbols        = 'fancy'
let g:Powerline_theme          = 'default'
let g:Powerline_colorscheme    = 'default'
let g:Powerline_stl_path_style = 'short'
if has('gui_running')
    if has('gui_win32')
        set guifont=Droid_Sans_Mono_Slashed_for_Pow:h10
        autocmd GUIEnter * :simalt ~x
    elseif has('gui_macvim')
        set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h11
        set lines=999 columns=999
        set transparency=7
    else
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11
    endif
    colorscheme seoul256
    set antialias
else
    if has('win32')
        colorscheme desert
    elseif has('mac')
        colorscheme seoul256
    else
        colorscheme seoul256
    endif
endif
let g:solarized_visibility='high'
set cursorline
set guioptions-=T
set guioptions-=m
set showtabline=2
behave xterm
set mousemodel=popup
set viminfo=/50,'50,h,<0,@0
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
execute 'set listchars+=tab:'   . nr2char(187) . nr2char(183)
execute 'set listchars+=eol:'   . nr2char(172)
execute 'set listchars+=nbsp:'  . nr2char(9251)
execute 'set listchars+=trail:' . nr2char(1776)
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
au BufNewFile,BufRead *.tt2 setf tt2
au BufNewFile,BufRead *.tt2html setf tt2html
au BufNewFile,BufRead *.tt2h setf tt2html
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
function! s:UrlDecode(str)
  let str = substitute(substitute(substitute(a:str,'%0[Aa]\n$','%0A',''),'%0[Aa]','\n','g'),'+',' ','g')
  return substitute(str,'%\(\x\x\)','\=nr2char("0x".submatch(1))','g')
endfunction
let s:unimpaired_html_entities = {
      \ 'nbsp':     160, 'iexcl':    161, 'cent':     162, 'pound':    163,
      \ 'curren':   164, 'yen':      165, 'brvbar':   166, 'sect':     167,
      \ 'uml':      168, 'copy':     169, 'ordf':     170, 'laquo':    171,
      \ 'not':      172, 'shy':      173, 'reg':      174, 'macr':     175,
      \ 'deg':      176, 'plusmn':   177, 'sup2':     178, 'sup3':     179,
      \ 'acute':    180, 'micro':    181, 'para':     182, 'middot':   183,
      \ 'cedil':    184, 'sup1':     185, 'ordm':     186, 'raquo':    187,
      \ 'frac14':   188, 'frac12':   189, 'frac34':   190, 'iquest':   191,
      \ 'Agrave':   192, 'Aacute':   193, 'Acirc':    194, 'Atilde':   195,
      \ 'Auml':     196, 'Aring':    197, 'AElig':    198, 'Ccedil':   199,
      \ 'Egrave':   200, 'Eacute':   201, 'Ecirc':    202, 'Euml':     203,
      \ 'Igrave':   204, 'Iacute':   205, 'Icirc':    206, 'Iuml':     207,
      \ 'ETH':      208, 'Ntilde':   209, 'Ograve':   210, 'Oacute':   211,
      \ 'Ocirc':    212, 'Otilde':   213, 'Ouml':     214, 'times':    215,
      \ 'Oslash':   216, 'Ugrave':   217, 'Uacute':   218, 'Ucirc':    219,
      \ 'Uuml':     220, 'Yacute':   221, 'THORN':    222, 'szlig':    223,
      \ 'agrave':   224, 'aacute':   225, 'acirc':    226, 'atilde':   227,
      \ 'auml':     228, 'aring':    229, 'aelig':    230, 'ccedil':   231,
      \ 'egrave':   232, 'eacute':   233, 'ecirc':    234, 'euml':     235,
      \ 'igrave':   236, 'iacute':   237, 'icirc':    238, 'iuml':     239,
      \ 'eth':      240, 'ntilde':   241, 'ograve':   242, 'oacute':   243,
      \ 'ocirc':    244, 'otilde':   245, 'ouml':     246, 'divide':   247,
      \ 'oslash':   248, 'ugrave':   249, 'uacute':   250, 'ucirc':    251,
      \ 'uuml':     252, 'yacute':   253, 'thorn':    254, 'yuml':     255,
      \ 'OElig':    338, 'oelig':    339, 'Scaron':   352, 'scaron':   353,
      \ 'Yuml':     376, 'circ':     710, 'tilde':    732, 'ensp':    8194,
      \ 'emsp':    8195, 'thinsp':  8201, 'zwnj':    8204, 'zwj':     8205,
      \ 'lrm':     8206, 'rlm':     8207, 'ndash':   8211, 'mdash':   8212,
      \ 'lsquo':   8216, 'rsquo':   8217, 'sbquo':   8218, 'ldquo':   8220,
      \ 'rdquo':   8221, 'bdquo':   8222, 'dagger':  8224, 'Dagger':  8225,
      \ 'permil':  8240, 'lsaquo':  8249, 'rsaquo':  8250, 'euro':    8364,
      \ 'fnof':     402, 'Alpha':    913, 'Beta':     914, 'Gamma':    915,
      \ 'Delta':    916, 'Epsilon':  917, 'Zeta':     918, 'Eta':      919,
      \ 'Theta':    920, 'Iota':     921, 'Kappa':    922, 'Lambda':   923,
      \ 'Mu':       924, 'Nu':       925, 'Xi':       926, 'Omicron':  927,
      \ 'Pi':       928, 'Rho':      929, 'Sigma':    931, 'Tau':      932,
      \ 'Upsilon':  933, 'Phi':      934, 'Chi':      935, 'Psi':      936,
      \ 'Omega':    937, 'alpha':    945, 'beta':     946, 'gamma':    947,
      \ 'delta':    948, 'epsilon':  949, 'zeta':     950, 'eta':      951,
      \ 'theta':    952, 'iota':     953, 'kappa':    954, 'lambda':   955,
      \ 'mu':       956, 'nu':       957, 'xi':       958, 'omicron':  959,
      \ 'pi':       960, 'rho':      961, 'sigmaf':   962, 'sigma':    963,
      \ 'tau':      964, 'upsilon':  965, 'phi':      966, 'chi':      967,
      \ 'psi':      968, 'omega':    969, 'thetasym': 977, 'upsih':    978,
      \ 'piv':      982, 'bull':    8226, 'hellip':  8230, 'prime':   8242,
      \ 'Prime':   8243, 'oline':   8254, 'frasl':   8260, 'weierp':  8472,
      \ 'image':   8465, 'real':    8476, 'trade':   8482, 'alefsym': 8501,
      \ 'larr':    8592, 'uarr':    8593, 'rarr':    8594, 'darr':    8595,
      \ 'harr':    8596, 'crarr':   8629, 'lArr':    8656, 'uArr':    8657,
      \ 'rArr':    8658, 'dArr':    8659, 'hArr':    8660, 'forall':  8704,
      \ 'part':    8706, 'exist':   8707, 'empty':   8709, 'nabla':   8711,
      \ 'isin':    8712, 'notin':   8713, 'ni':      8715, 'prod':    8719,
      \ 'sum':     8721, 'minus':   8722, 'lowast':  8727, 'radic':   8730,
      \ 'prop':    8733, 'infin':   8734, 'ang':     8736, 'and':     8743,
      \ 'or':      8744, 'cap':     8745, 'cup':     8746, 'int':     8747,
      \ 'there4':  8756, 'sim':     8764, 'cong':    8773, 'asymp':   8776,
      \ 'ne':      8800, 'equiv':   8801, 'le':      8804, 'ge':      8805,
      \ 'sub':     8834, 'sup':     8835, 'nsub':    8836, 'sube':    8838,
      \ 'supe':    8839, 'oplus':   8853, 'otimes':  8855, 'perp':    8869,
      \ 'sdot':    8901, 'lceil':   8968, 'rceil':   8969, 'lfloor':  8970,
      \ 'rfloor':  8971, 'lang':    9001, 'rang':    9002, 'loz':     9674,
      \ 'spades':  9824, 'clubs':   9827, 'hearts':  9829, 'diams':   9830,
      \ 'apos':      39}
function! s:XmlEntityDecode(str)
  let str = substitute(a:str,'\c&#\%(0*38\|x0*26\);','&amp;','g')
  let str = substitute(str,'\c&#\(\d\+\);','\=nr2char(submatch(1))','g')
  let str = substitute(str,'\c&#\(x\x\+\);','\=nr2char("0".submatch(1))','g')
  let str = substitute(str,'\c&apos;',"'",'g')
  let str = substitute(str,'\c&quot;','"','g')
  let str = substitute(str,'\c&gt;','>','g')
  let str = substitute(str,'\c&lt;','<','g')
  let str = substitute(str,'\C&\(\%(amp;\)\@!\w*\);','\=nr2char(get(g:unimpaired_html_entities,submatch(1),63))','g')
  return substitute(str,'\c&amp;','\&','g')
endfunction
function! s:AlignChar( char, list )
    let list = a:list
    let char = a:char
    let maxLen = max( map( copy(list), 'match(v:val, "' . char . '")' ) )
    let fixedLines = []
    for line in list
        let thisLen = match(line, char)
        let replStr = repeat(' ', (maxLen - thisLen) + 1)
        call add( fixedLines, substitute(line, '^[^' . char . ']\+\zs' . char . '\s*', replStr . char . ' ', '') )
    endfor
    return fixedLines
endfunction
function! s:CleanURL( URL )
    let decoded    = s:UrlDecode(substitute(a:URL, '\&amp;', '\&', 'g'))
    let tmpDecoded = s:UrlDecode(substitute(decoded, '\&amp;', '\&', 'g'))
    while decoded != tmpDecoded
        let decoded    = tmpDecoded
        let tmpDecoded = s:UrlDecode(substitute(decoded, '\&amp;', '\&', 'g'))
    endwhile
    let [target; params] = split( decoded, '\ze[?&;]' )
    let rtn = s:AlignChar( '=', map( params, 'substitute( v:val, ''^\(.\)'', ''    \1 '', "")' ) )
    return ['    ' . target, ''] + rtn
endfunction
function! s:CleanLine( line )
    let line = a:line
    let httpCommands    = ['POST', 'PUT', 'GET']
    let allHttpCommands = join(httpCommands, '\|')
    let httpParser      = '^.\{-}\('  . allHttpCommands . '\)\s*\(.\{-}\)\s*\(HTTP/1\.[10]\)\(.\{-}\)\s*$'
    let tmpLines = []
    if match( line, httpParser ) >= 0
        let parts = matchlist( line, httpParser )
        call add( tmpLines, parts[1] )
        call extend( tmpLines, s:CleanURL( parts[2] ) )
        call add( tmpLines, '  ' . parts[3] )
        let rest = parts[4]
        let rest = substitute( rest, '^\%(\\r\\n\)\+\s*\|\s*\%(\\r\\n\)\+\$', '', 'g' )
        let restLines = s:AlignChar( ':', split( rest, '\s*\%(\\r\\n\)\+\s*' ) )
        for restLine in restLines
            if restLine =~ '^Cookie'
                let [cookieStr; cookies] = map( split( restLine, '\%(^Cookie\zs:\|;\) \+' ), '"    " . v:val' )
                call add( tmpLines, 'Cookies:' )
                call extend( tmpLines, s:AlignChar( '=', cookies) )
            else
                if restLine =~ '/^Referer:/'
                    call add( tmpLines, s:UrlDecode(restLine) )
                else
                    call add( tmpLines, restLine )
                endif
            endif
        endfor
    elseif line != ''
        call add( tmpLines, line )
    endif
    return tmpLines
endfunction
function! s:CleanUpSourcefire()
    let spacerStr = repeat( '*-', 60 )
    let spacer = ['', '', '', spacerStr, '', '', '']
    let allLines = getline(1, '$')
    let curLine = 1
    let firstItem = 1
    for line in allLines
        let cleanedLines = s:CleanLine( line )
        if len(cleanedLines) > 0
            if !firstItem
                call setline( curLine, spacer )
                let curLine = curLine + len( spacer )
            else
                let firstItem = 0
            endif
            call setline( curLine, cleanedLines )
            let curLine = curLine + len( cleanedLines )
        endif
    endfor
endfunction
command! -register CleanUpSourcefire call s:CleanUpSourcefire()
map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos    = 'left'
let NERDTreeChDirMode = '2'
let NERDTreeIgnore    = ['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
if !exists('g:FuzzyFinderOptions')
    let g:FuzzyFinderOptions                       = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
    let g:FuzzyFinderOptions.File.excluded_path    = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.{1,2}[/\\]$)|\.pyo$|\.pyc$|\.svn[/\\]$'
    let g:FuzzyFinderOptions.Base.key_open_Tabpage = '<Space>'
endif
let g:fuzzy_matching_limit = 60
let g:fuzzy_ceiling        = 50000
let g:fuzzy_ignore         = "*.log;*.pyc;*.svn;*.git"
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
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
let g:indent_guides_enable_on_vim_startup = 1
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 0
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr> <CR> pumvisible() ? neocomplcache#close_popup() : '<Plug>delimitMateCR'
inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
map ,, <Plug>(easymotion-prefix)
nmap ,f <Plug>(easymotion-s2)
nmap ,t <Plug>(easymotion-bd-t2)
map ,l <Plug>(easymotion-lineforward)
map ,j <Plug>(easymotion-j)
map ,k <Plug>(easymotion-k)
map ,h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
let g:EasyMotion_smartcase = 1
omap ,n <Plug>(easyoperator-line-select)
xmap ,n <Plug>(easyoperator-line-select)
nmap d,n <Plug>(easyoperator-line-delete)
nmap p,n <Plug>(easyoperator-line-yank)
omap ,p <Plug>(easyoperator-phrase-select)
xmap ,p <Plug>(easyoperator-phrase-select)
nmap d,p <Plug>(easyoperator-phrase-delete)
nmap p,p <Plug>(easyoperator-phrase-yank)
let tlist_perl_settings = 'perl;u:use;r:role;e:extends;c:constant;t:const;a:attribute;s:subroutine;m:mooose doc'
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Sort_Type = "name"
let Tlist_WinWidth = 45
let g:session_autosave = 'no'
let g:session_autoload = 'no'
let g:syntastic_enable_perl_checker = 1
let g:loaded_syntastic_perl_perlcritic_checker = 1
cmap w!! w !sudo tee % >/dev/null
vnoremap ; :
noremap <Space> <PageDown>
inoremap kj <Esc>
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
nnoremap <F4> :set nowrap!<CR>
nnoremap <F5> :UndotreeToggle<CR>
noremap <F7> :setlocal spell! spell?<CR>
noremap <F2> :tab sball<CR>
noremap <F3> :Rearrangetabsbypath 1<CR>
nnoremap <S-l> :tabnext<CR>
nnoremap <S-h> :tabprevious<CR>
nnoremap <silent><A-.> m`:s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<CR>``:noh<CR>
nnoremap <silent><A-,> m`:s/\v(<\k+>)(.{-})(<\k*%#\k*>)/\3\2\1/<CR>``:noh<CR>
noremap <silent><A-n> k:call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
noremap <silent><A-m> :call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^
noremap <silent><C-h> h
noremap <silent><C-j> j
noremap <silent><C-k> k
noremap <silent><C-l> l
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
nnoremap \ttt :execute "normal a" . strftime("%F %T (%Z :: %z)")<Esc>
inoremap \ttt <Esc>:execute "normal a" . strftime("%F %T (%Z :: %z)")<Esc>a
noremap \u :sort u<CR>:g/^$/d<CR>
noremap \= :Align =><CR>
noremap ,ap vip:Align =><CR>
noremap ,ab vibwk:Align =><CR>
noremap ,aB viB:Align =><CR>
noremap ,a] vi]:Align =><CR>
noremap ,sp vip:sort<CR>
noremap ,sb vibwk:sort<CR>
noremap ,sB viB:sort<CR>
noremap ,s] vi]:sort<CR>
noremap ,asp vip:Align =><CR>vip:sort<CR>
noremap ,asb vibwk:Align =><CR>vibwk:sort<CR>
noremap ,asB viB:Align =><CR>viB:sort<CR>
noremap ,as] vi]:Align =><CR>vi]:sort<CR>
noremap \m :CopyMatches<CR>:tabnew<CR>"+p<CR>:sort u<CR>:g/^$/d<CR>:1,$y+<CR>
noremap \fd :tabnew<CR>V"+p:silent %!perl -MModern::Perl -MDateTimeX::Easy -ne"BEGIN{sub fd{my $line = shift;chomp $line;my $dt = DateTimeX::Easy->parse($line);$dt ? ($dt->year < 1950 ? $dt->add(years => 100) : $dt)->strftime('\%Y-\%m-\%d \%H:\%M:\%S') : $line}; use Memoize; memoize 'fd'}say join qq{\t}, map {fd($_)} split qq{\t}, $_"<CR>"+1,$y<CR>
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
noremap \fb mcHmt:g/^ *{ *$/norm kJ:s/ *{ *$/ {/<CR>:silent :noh<CR>'tzt`c
noremap ,v :vne<CR>
noremap ,q  qqqqq
noremap ,m :CopyMatches<CR>
noremap ,u :sort u<CR>:g/^$/d<CR>
noremap ,cl :sort<CR>:%!uniq -c<CR>:sort! n<CR>
noremap ,a  qaq
noremap ,td :%s/\(\<[a-zA-Z0-9_-]*[a-zA-Z][a-zA-Z0-9_-]*\)\.[a-zA-Z0-9_.-]*\>/\1/<CR>:silent noh<CR>
noremap ,i :g/^$/d<CR>:%s/\v^(.*)$/   ,'\1'/<CR>:1s/   ,/(\r    <CR>:$s/$/\r)<CR>:silent noh<CR>"+:1,$y+<CR>
noremap ,cab :tab sball<CR>:tabdo :bd!<CR>:tab sball<CR>:tabdo :bd!<CR>
noremap ,cd :cd %:p:h<CR>
noremap ,sep :g/^\(\S\+\).\+\n\1\@!/s/$/\r<CR>:silent noh<CR>
noremap ,dupe :sort<CR>:g/^\(.\+\)\n\1\@!/d<CR>yyp:%s/^\(.\+\)\n\1\+/\1/<CR>:g/^$/d<CR>:silent noh<CR>
noremap ,conf :tabnew $VIMHOME/vimconfigs/
noremap ,tl :Tlist<CR>
nmap <silent> <C-F11> :if &guioptions=~'m' \| set guioptions-=m \| else \| set guioptions+=m \| endif<CR>
noremap <silent> \rti :silent %!perl -nMNet::IP -MNet::Netmask -MModern::Perl -e'chomp;my $n = Net::IP->new(Net::Netmask->new($_));say join "\t", $n->intip, $n->last_int'<CR>
noremap <silent> \tip :silent %!perl -MModern::Perl=2011 -MNet::IP -ne 'chomp;say /^(?:\d{1,3}\.){3}\d{1,3}$/ ? Net::IP->new($_)->intip : $_'<CR>
noremap <silent> \rs :set nowrap<CR>ggdG"+p:%s/\s\+/\r/e<CR>:silent noh<CR>:sort u<CR>ggVGJ:s/#N[\/\\]A\>\s*//ie<CR>:silent noh<CR>$V
noremap <silent> ,run :Tube perl %<CR>
noremap <silent> ,sl :%s/\t/\r/<CR>
noremap <silent> \el :silent %!perl -MModern::Perl=2011 -MHTML::TreeBuilder -MText::Trim -e 'my$h=HTML::TreeBuilder->new;while(<>){$h->parse($_)}$h->eof;my \%l;for my $li(@{$h->elementify->extract_links}){my $ln=trim $li->[0];$l{$ln}++ unless $ln =~ /^(?:\#<bar>\s*$)/;}say $_ for sort keys \%l'<CR>
noremap <silent> \deps :let @q=':v/^declare.*app_classpath=/d<c-v><cr>dt"lds":%s/:*\$lib_dir\//\rwrapper.java.classpath.1 = lib\/<c-v><cr>ggddf1<c-v><c-v>1234j:I<c-v><cr>\ca'<ESC>@q
noremap <silent> ,jl :silent :%s/^\s*\(.\{-}\)\s*$/,"\1"<CR> ggVGgJ0x
noremap \sqld :%s/:.*\zsInt/0/e<bar>%s/:.*\zsLong/0L/e<bar>%s/:.*\zsString/""/e<bar>%s/:.*\zsBigDecimal/BigDecimal(0)/e<bar>%s/:.*\zsTimestamp/new Timestamp(0L)/e<bar>%s/:.*\zsBoolean/true/e<bar>%s/:.*\zsDouble/0.0/e<bar>%s/: *\zsOption\[\(.*\)\]/Some(\1)/e<bar>%s/.*\s\(\S\+\):\s\+\(.\+\)\%(,\<bar>)\s*{.*\)\s*\%(\/\/\ze.*\)*$/\2, \/\/ \1/e<CR>
noremap ,,j 9999999999j
noremap ,,k 9999999999k
abb teh the
abb fo of
abb taht that
abb wehn when
inoremap qw/<SPACE>     qw/<SPACE><SPACE>/<Left><Left>
inoremap qw/;     qw/<SPACE><SPACE>/;<Left><Left><Left>
inoremap qw/<CR> qw/<CR>/;<Esc>O<Tab>
inoremap qr{<CR> qr{<CR>}xms;<Esc>O<Tab>
