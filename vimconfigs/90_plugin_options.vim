" ---------------------------------------
" |  Configures all the plugin options  |
" ---------------------------------------

"  -----------
"  |  slimv  |
"  -----------

let g:slimv_python           = 'C:/Python31/python.exe'
let g:slimv_lisp             = '"java -cp C:/clojure/clojure.jar;C:/clojure/clojure-contrib.jar clojure.main"'
let g:lisp_rainbow           = 1
let g:clj_highlight_builtins = 1

" Stupid plugin breaks delimitMate so forcibly remove it!
let g:paredit_loaded         = 0



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
let g:neocomplcache_enable_camel_case_completion = 1

" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1

" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()




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


"  ----------------
"  |  BlockInsert  |
"  ----------------

vmap <leader>i  <plug>blockinsert-i
vmap <leader>a  <plug>blockinsert-a

nmap <leader>i  <plug>blockinsert-i
nmap <leader>a  <plug>blockinsert-a

vmap <leader>[]  <plug>blockinsert-b
vmap <leader>q[] <plug>blockinsert-qb

nmap <leader>[]  <plug>blockinsert-b
nmap <leader>q[] <plug>blockinsert-qb




"==================================================
"==                   DISABLED                   ==
"==================================================
""
"" "  --------------
"" "  |  SuperTab  |
"" "  --------------
""
"" let g:SuperTabMappingForward = '<C-tab>'
"" let g:SuperTabMappingTabLiteral = '<S-C-tab>'
"" let g:SuperTabDefaultCompletionType="context"



""
""
"" "  ---------------------
"" "  |  miniBufExplorer  |
"" "  ---------------------
""
"" let g:miniBufExplMapWindowNavArrows = 1
"" let g:miniBufExplMapCTabSwitchBufs  = 1
"" let g:miniBufExplModSelTarget       = 1
"" let g:miniBufExplorerMoreThanOne    = 1
"" let g:miniBufExplUseSingleClick     = 1
