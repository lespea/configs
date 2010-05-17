" ---------------------------------------
" |  Configures all the plugin options  |
" ---------------------------------------

"  -----------
"  |  slimv  |
"  -----------

let g:slimv_python = 'C:/Python26/python.exe'
let g:slimv_lisp = '"java -cp C:/clojure/clojure.jar;C:/clojure/clojure-contrib.jar clojure.main"'
let g:lisp_rainbow = 1



"  --------------
"  |  NERDTree  |
"  --------------

map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos='left'
let NERDTreeChDirMode='2'
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']



"  -----------------
"  |  FuzzyFinder  |
"  -----------------

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



"  ----------------
"  |  XPTemplate  |
"  ----------------

"  Turn off brace completion (it sucks)
let g:xptemplate_brace_complete = ''

"  XPT uses Control-Space as trigger key
let g:xptemplate_key = '<C-Space>'

"  Use <tab>/<S-tab> to navigate through pum. Optional
let g:xptemplate_pum_tab_nav = 1



"  -------------------
"  |  NeoComplCache  |
"  -------------------

"  Use neocomplcache.
let g:NeoComplCache_EnableAtStartup = 1

"  Use smartcase.
let g:NeoComplCache_SmartCase = 1

"  Use camel case completion.
"let g:NeoComplCache_EnableCamelCaseCompletion = 1

"  Use underbar completion.
let g:NeoComplCache_EnableUnderbarCompletion = 1

"  Set minimum syntax keyword length.
let g:NeoComplCache_MinSyntaxLength = 3

"  Set manual completion length.
let g:NeoComplCache_ManualCompletionStartLength = 0

"  Set minimum keyword length.
let g:NeoComplCache_MinKeywordLength = 3

"  Print caching percent in statusline.
"let g:NeoComplCache_CachingPercentInStatusline = 1 



"  -----------------
"  |  delimitMate  |
"  -----------------

"  Match pairs of '/' for perl
au FileType perl let b:delimitMate_matchpairs = "(:),[:],{:},<:>"

"  Don't match quotes in vim
au FileType vim  let b:delimitMate_smart_quotes = 0

"  Expand spaces and newlines
let b:delimitMate_expand_space = 1
let b:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1






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