" ------------------------------------------------
" |  Configures how to treat certain file types  |
" ------------------------------------------------

"  No line numbers when viewing help
au FileType helpfile set nonumber

"  Enter selects subject
au FileType helpfile nnoremap <buffer><cr> <c-]>

"  Backspace to go back
au FileType helpfile nnoremap <buffer><bs> <c-T>


"  HTML is XHTML
au BufNewFile,BufRead *.html        setf xhtml

"  All my perls
au BufNewFile,BufRead *.pl,*.pm,*.t setf perl
"au FileType perl setlocal keywordprg=perldoc\ -T\ -f
autocmd FileType perl noremap K :!echo <cWORD> <cword> <bar> perl -e '$line = <STDIN>; if ($line =~ /(\w+::\w+)/){exec("perldoc $1")} elsif($line =~ /(\w+)/){exec "perldoc -f $1 <bar><bar> perldoc $1"}'<cr><cr>

"  Ensure relativenumber is set
au BufRead * set rnu


" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ -T\ \"%\"\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

"  use taglist with perl
autocmd FileType perl Tlist

"  For C-like programming, have automatic indentation
autocmd FileType c,cpp,slang        set cindent

"  For actual C (not C++) programming where comments have explicit end characters, if starting
"  a new line in the middle of a comment automatically insert the comment leader characters
autocmd FileType c set formatoptions+=ro

"  For Perl programming, have things in braces indenting themselves
"      Actually not -- this just makes me angry.  perl will indent fine by
"      itself
"autocmd FileType perl set smartindent

"  Python formatting
autocmd FileType python set formatoptions-=t

"  For CSS, also have things in braces indented:
autocmd FileType css set smartindent

"  For HTML, generally format text, but if a long line has been created leave it alone when editing
autocmd FileType html  set formatoptions+=tl
autocmd FileType xhtml set formatoptions+=tl


" my perl includes pod
let perl_include_pod = 1

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1


" Omni Completion
autocmd FileType php  setlocal  omnifunc=phpcomplete#CompletePHP
autocmd FileType c    setlocal  omnifunc=ccomplete#Complete

autocmd FileType css            setlocal  omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown  setlocal  omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript     setlocal  omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python         setlocal  omnifunc=pythoncomplete#Complete
autocmd FileType xml            setlocal  omnifunc=xmlcomplete#CompleteTags

au BufNewFile,BufRead *.tt2 setf tt2
au BufNewFile,BufRead *.tt2html setf tt2html
