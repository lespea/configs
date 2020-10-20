" ------------------------------------
" |  Setup the base features of vim  |
" ------------------------------------

"  This is the 21st century
set nocompatible

"  Clear any existing autocommands:
autocmd!

"  Enable utf8 in our configs
set encoding=utf-8

" Figure out where we really are
let $VIMHOME=fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Where to load our plugins
call plug#begin('$HOME/.vimplugged')

Plug 'inkarkat/vim-ingo-library'
Plug 'vim-scripts/L9'

Plug 'PProvost/vim-ps1'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/NrrwRgn'
Plug 'chrisbra/SudoEdit.vim'
Plug 'chrisbra/csv.vim'
Plug 'chrisbra/unicode.vim'
Plug 'derekwyatt/vim-scala'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'godlygeek/tabular'
Plug 'gregsexton/MatchTag'
Plug 'hail2u/vim-css3-syntax'
Plug 'honza/vim-snippets'
Plug 'iiey/visincr'
Plug 'inkarkat/vim-AdvancedSorters'
Plug 'inkarkat/vim-ChangeGloballySmartCase'
Plug 'inkarkat/vim-CursorLineCurrentWindow'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'mtdl9/vim-log-highlighting'
Plug 'myusuf3/numbers.vim'
Plug 'pearofducks/ansible-vim'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'qpkorr/vim-renamer'
Plug 'rust-lang/rust.vim'
Plug 's3rvac/vim-syntax-yara'
Plug 'sbdchd/neoformat'
Plug 'taku-o/vim-reorder-columns'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'triglav/vim-visual-increment'
Plug 'tweekmonster/braceless.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/LargeFile'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'

" Initialize plugin system
call plug#end()

let g:loaded_python_provider = 0
let g:python_host_prog = ''
let g:python3_host_prog = expand('$HOME/.virtualenvs/nvim3/bin/python')

"Plug 'vim-syntastic/syntastic'
