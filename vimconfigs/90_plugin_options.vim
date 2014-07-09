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
"  |  VimClojure   |
"  -----------------
let g:vimclojure#ParenRainbow        = 1
let g:vimclojure#DynamicHighlighting = 1
let g:vimclojure#WantNailgun = 1
let g:vimclojure#SplitPos = "bottom"
let g:vimclojure#SplitSize = 13




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
let g:fuzzy_ignore         = "*.log;*.pyc;*.svn;"
map <silent> \f :FufFile<CR>
map <silent> \b :FufBuffer<CR>



"  ----------------
"  |  XPTemplate  |
"  ----------------

"  Turn off brace completion (it sucks and delimitMate is much better)
let g:xptemplate_brace_complete = ''

"  XPT uses Control-Space as trigger key
let g:xptemplate_key = '<C-Space>'

"  Use <tab>/<S-tab> to navigate through pum. Optional
let g:xptemplate_pum_tab_nav = 1

let g:xptemplate_vars="$author=Adam Lesperance"
let g:xptemplate_vars="$email=lespea@gmail.com"



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

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1

" Use smartcase.
let g:neocomplcache_enable_smart_case = 1

" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 0

" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 0

" Set minimum syntax keyword length.
" let g:neocomplcache_min_syntax_length = 3

" SuperTab like snippets behavior.
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" <CR>: close popup and save indent.
imap <expr> <CR> pumvisible() ? neocomplcache#close_popup() : '<Plug>delimitMateCR'


" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()



"  ----------------
"  |  EasyMotion  |
"  ----------------
"  <leader> is too far away
let g:EasyMotion_leader_key = ','



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


"  -----------------
"  |  FuzzyFinder  |
"  -----------------
let g:tube_terminal         = 'iterm'
let g:tube_enable_shortcuts = 1


"  -------------
"  |  Session  |
"  -------------
:let g:session_autosave = 'no'
:let g:session_autoload = 'no'