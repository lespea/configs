" ----------------------------------------------
" |  Configures my personal shortcut mappings  |
" ----------------------------------------------

" ------------
" |  Normal  |
" ------------

"  Use space to page down
noremap <Space> <PageDown>

"  Super fast insert exiting
imap jj <Esc>
imap jk <Esc>

"  Have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

"  Have Y behave analogously to D and C rather than to dd and cc (which is already done by yy):
noremap Y y$


" ------------
" |  F-Keys  |
" ------------

"  Have <F1> prompt for a help topic, rather than displaying the introduction page
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

"  Remove all trailing spaces
map <F9> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))<CR>

"  Paste toggler
nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>

"  Spellcheck the current file
nn <F7> :setlocal spell! spell?<CR>

"  Turn all the buffers to tabs
nn <F2> :tab sball<CR>


" --------------
" |  Modified  |
" --------------

"  Cycle through the tabs
nnoremap <C-L> :tabnext<CR>
nnoremap <C-H> :tabprevious<CR>

"  Above/below adding and creating
nnoremap <silent><A-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

"  Swap the next/previous word
nnoremap <silent><A-m> m`:s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<CR>``:noh<CR>
nnoremap <silent><A-n> m`:s/\v(<\k+>)(.{-})(<\k*%#\k*>)/\3\2\1/<CR>``:noh<CR>

" Move up or down with same indent level
nn <M-,> k:call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
nn <M-.> :call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^

" Turn off highlighted search
map <silent> <C-N> :silent noh<CR>

"  Shortcuts that insert surrounding space as reqeuested
inoremap <S-CR> <Esc>
nnoremap <S-space> i <esc>la <esc>h
noremap  <C-S-space> lBi <esc>Ea <esc>B

"  Pasting
noremap     <S-Insert> "+gP
vnoremap    <S-Insert> "+gP
cmap        <S-Insert> <C-R>+

"  Yanking
vnoremap <C-C>      "+y
vnoremap <C-Insert> "+y

"  Open up a new tab
noremap <C-T> :tabnew<CR>

"  Delete the current buffer
nmap <C-F4> :bd<CR>


" ------------
" |  Leader  |
" ------------

"  Really quit
noremap \qa :qa!<CR>

"  Toggle line numbers
nnoremap \tn :set number!<Bar> set number?<CR>

"  Really clear the search buffer, not just remove the highlight
map \c :let @/ = ""<CR>

"  Undo all local changes
nnoremap \r :e!<CR>

"  Insert THE time!
nmap \ttt :execute "normal a" . strftime("%x %X (%Z)")<Esc>
imap \ttt <Esc>:execute "normal a" . strftime("%x %X (%Z)")<Esc>a

"  Remove dupes
:noremap \u :sort u<CR>:g/^$/d<CR>

"  Align on =>  (useful for hash assignments)
:noremap \= :Align =><CR>

"  Copy the matches to a new buffer, remove the duplicates/blank lines, and copy to the clipboard
:noremap \m :CopyMatches<CR>:tabnew<CR>"+p<CR>:sort u<CR>:g/^$/d<CR>ggVG"+y

"  Takes a bunch of "invalid" dates and makes them usable in Excel
:noremap \fd :%s/\v(\d{1,2})\/(\d{1,2})\/(\d{4})/\3\/\1\/\2/<CR>

"  Setups up a new quick-diff window
:noremap \dn :tabnew<CR>:diffthis<CR>:vne<CR>:diffthis<CR>
:noremap \dt :diffthis<CR>:vne<CR>:diffthis<CR>
:noremap ,du :diffupdate<CR>

"  Toggle paste on/off
nnoremap \tp :set invpaste paste?<CR>

"  Toggle the display of "invisible" characters
nnoremap \tl :set invlist!<CR>

"  Copies everything into the clipboard
nnoremap \ca ggVG"+y

"  Easy edit/sourcing of vimrc
nmap \s :source $MYVIMRC<CR>
nmap \v :tabnew $MYVIMRC<CR>

"  Shortcut to start editing a snippet file
nmap \snip :tabnew $HOME\\vimfiles\\snippets\\

"  Jump to the IRM module folder
nmap \mod  :tabnew C:\\Work\\irm_vm\\Modules\\trunk\\IRM\\

"  Jump to the IRM script folder
nmap \script  :tabnew C:\\Work\\irm_vm\\Scripts\\trunk\\

"  Shortcuts to save various "scratch" sessions
noremap \sa :SessionSaveAs scratcha<CR>
noremap \sb :SessionSaveAs scratchb<CR>
noremap \qs :SessionSaveAs quitscrach<CR>:qa!<CR>


" -----------
" |  Comma  |
" -----------

"  Use relavent line numbers
:noremap ,h :RN<CR>

"  Vertical split in a new buffer
:noremap ,v :vne<CR>

"  Clear the q register and then begin recording to it (for recursive recordings)
:noremap ,q  qqqqq

"  Copy the matches to the clipboard (slow?)
:noremap ,m :CopyMatches<CR>

"  Remove dupes
:noremap ,u :sort u<CR>:g/^$/d<CR>

"  Clear the (a)ll register
:noremap ,a  qaq

"  Trim the domain from every line (abc.uhc.com => abc)
:noremap ,t :%s/\..*//<CR>

"  Takes all of the lines and formats them for a sql "IN" query part
:noremap ,i :%s/\v^(.*)$/    '\1',/<CR>G$xo)<Esc>ggO(<Esc>:silent noh<CR>

"  Shortcuts to save various "scratch" sessions
noremap ,sa :SessionOpen scratcha<CR>
noremap ,sb :SessionOpen scratchb<CR>
noremap ,qs :SessionOpen quitscrach<CR>

"  Close all of the open buffers (force close so be careful!)
noremap ,cab :tabdo :bd!<CR>
