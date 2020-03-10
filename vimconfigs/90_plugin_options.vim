" ---------------------------------------
" |  Configures all the plugin options  |
" ---------------------------------------



"  --------------
"  |  NERDTree  |
"  --------------

map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos    = 'left'
let NERDTreeChDirMode = '2'
let NERDTreeIgnore    = ['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']




"  -----------------
"  |  FuzzyFinder  |
"  -----------------

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



"  ----------------
"  |  XPTemplate  |
"  ----------------

"  Turn off brace completion (it sucks and delimitMate is much better)
"let g:xptemplate_brace_complete = ''

"  XPT uses Control-Space as trigger key
"let g:xptemplate_key = '<C-Space>'

"  Use <tab>/<S-tab> to navigate through pum. Optional
"let g:xptemplate_pum_tab_nav = 1

"let g:xptemplate_vars="$author=Adam Lesperance"
"let g:xptemplate_vars="$email=lespea@gmail.com"



"  -----------------
"  |  delimitMate  |
"  -----------------

"  Don't match double quotes in vim (they're comments)
au FileType vim  let b:delimitMate_quotes = " ' ` *"

"  Force pairs so they're always what I expect
let g:delimitMate_matchpairs = "(:),[:],{:}"

"  Expand spaces and newlines
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_balance_matchpairs = 1

"au FileType c,perl,javascript,java let b:delimitMate_eol_marker = ";"


"  ---------------
"  |  EasyAlign  |
"  ---------------

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)



"  -----------------
"  |  InsertGuide  |
"  -----------------

let g:indent_guides_enable_on_vim_startup = 1



"  -------------------
"  |  NeoComplCache  |
"  -------------------

" Use neocomplete.
"let g:neocomplete#enable_at_startup = 1
" Use smartcase.
"let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
"let g:neocomplete#sources#syntax#min_keyword_length = 3

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


"  ----------------
"  |  EasyMotion  |
"  ----------------
"  <leader> is too far away
map ,, <Plug>(easymotion-prefix)

" Gif config
nmap ,f <Plug>(easymotion-s2)
nmap ,t <Plug>(easymotion-bd-t2)

" Gif config
"map  / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
"map n <Plug>(easymotion-next)
"map N <Plug>(easymotion-prev)

" Gif config
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



"  ---------------
"  |  Colorizer  |
"  ---------------
"let g:colorizer_auto_filetype='css,html,xhtml,less'



"  -------------
"  |  TagList  |
"  -------------
let tlist_perl_settings = 'perl;u:use;r:role;e:extends;c:constant;t:const;a:attribute;s:subroutine;m:mooose doc'
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Sort_Type = "name"
let Tlist_WinWidth = 45



"  -------------
"  |  Session  |
"  -------------
let g:session_autosave = 'no'
let g:session_autoload = 'no'



"  ---------------
"  |  Syntastic  |
"  ---------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_ignore_files = ['\m\.sbt$', '\m\.scala$']


let g:ycm_server_keep_logfiles = 0

let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


" YCM-UltiSnip-SuperTab:
" ------------------------------
""""   let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
""""   let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
""""   let g:SuperTabDefaultCompletionType = '<C-n>'
""""
""""   " better key bindings for UltiSnipsExpandTrigger
""""   let g:UltiSnipsExpandTrigger="<c-Space>"
""""   let g:UltiSnipsJumpForwardTrigger = "<tab>" " you can use <c-j>
""""   let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
""""   " UltiSnip
""""   " ---------
""""   let g:UltiSnipsEditSplit="vertical"
""""   let g:UltiSnipsSnippetDirectories=['MyUltiSnips']
""""   let g:UltiSnipsListSnippets="<c-l>"
""""   " YCM
""""   " ------
""""   let g:ycm_complete_in_comments = 1
""""   let g:ycm_seed_identifiers_with_syntax = 1
""""   let g:ycm_collect_identifiers_from_comments_and_strings = 1
""""   "let g:ycm_rust_src_path = "$VIMHOME/rust"
"
"" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


"  --------------
"  |  NeoFormat  |
"  --------------
let g:neoformat_python_autopep8 = {
            \ 'exe': 'autopep8',
            \ 'args': ['-s 4', '--max-line-length 120', '-E'],
            \ 'replace': 1,
            \ 'stdin': 1,
            \ 'no_append': 1,
            \ }

let g:neoformat_python_yapf = {
            \ 'exe': 'yapf',
            \ 'args': ['--style="{based_on_style: chromium, column_limit: 120, indent_width: 4}"'],
            \ 'stdin': 1,
            \ }

let g:neoformat_enabled_python = ['yapf']


" Disable markdown folding
let g:vim_markdown_folding_disabled = 1


let g:airline_powerline_fonts = 1
let g:airline_solarized_bg    = 'dark'
let g:airline_theme           = 'tomorrow'
