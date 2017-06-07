" ------------------------------------
" |  Setup the base features of vim  |
" ------------------------------------

"  This is the 21st century
set nocompatible

"  Clear any existing autocommands:
autocmd!

"  Load all of our plugins
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

"  Enable utf8 in our configs
set encoding=utf-8

let $VIMHOME=fnamemodify(resolve(expand('<sfile>:p')), ':h')

let g:python_host_prog=expand('$HOME/.virtualenvs/nvim2/bin/python')
let g:python3_host_prog=expand('$HOME/.virtualenvs/nvim3/bin/python')
