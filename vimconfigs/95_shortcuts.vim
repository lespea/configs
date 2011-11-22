
" ------------
" |  Normal  |
" ------------

"  For when you forget sudo
cmap w!! w !sudo tee % >/dev/null

" ------------
" |  Normal  |
" ------------

"  Fast command mode
vnoremap ; :

"  Use space to page down
noremap <Space> <PageDown>

"  Super fast insert-mode exiting
inoremap kj <Esc>

"  Move correctly for wrapped lines
nnoremap j gj
nnoremap k gk

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
vnoremap <F1> <C-C><F1>
noremap  <F1> <C-C><F1>
noremap! <F1> <C-C><F1>

"  Remove all trailing spaces
noremap <F9> :StripTrailingWhitespaces<CR>

"  Changes tabs back to spaces
noremap <F10> :set expandtab<CR>:retab<CR>

"  Paste toggler
nnoremap <F4> :set nowrap!<CR>

nnoremap <F5> :GundoToggle<CR>

"  Spellcheck the current file
noremap <F7> :setlocal spell! spell?<CR>

"  Turn all the buffers to tabs
noremap <F2> :tab sball<CR>

"  Rearrange all of the tabs by their path
noremap <F3> :Rearrangetabsbypath 1<CR>


" --------------
" |  Modified  |
" --------------

"  Cycle through the tabs
nnoremap <C-L> :tabnext<CR>
nnoremap <C-H> :tabprevious<CR>

"  Above/below adding and creating lines
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

"  Swap the next/previous word
nnoremap <silent><A-.> m`:s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<CR>``:noh<CR>
nnoremap <silent><A-,> m`:s/\v(<\k+>)(.{-})(<\k*%#\k*>)/\3\2\1/<CR>``:noh<CR>

" Move up or down with same indent level
noremap <silent><A-n> k:call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
noremap <silent><A-m> :call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^

" Turn off highlighted search
noremap <silent><C-N> :silent noh<CR>

"  Shortcuts that insert surrounding space as reqeuested
nnoremap <S-space> i <esc>la <esc>h
noremap  <S-C-space> m`lBi <esc>Ea <esc>``l

"  Pasting
noremap     <S-Insert>  "+gP
noremap     <C-S>       "+gP
vnoremap    <S-Insert>  "+gP
cnoremap    <S-Insert>  <C-R>+
cnoremap    <C-S>       <C-R>+

"  Yanking
vnoremap <C-C>      "+y
vnoremap <C-Insert> "+y

"  Open up a new tab
noremap <C-T> :tabnew<CR>

"  Delete the current buffer
nnoremap <C-F4> :bd<CR>


" ------------
" |  Leader  |
" ------------

"  Really quit
noremap \qa :qa!<CR>

"  Toggle line numbers
nnoremap \tn :set number!<Bar> set number?<CR>

"  Really clear the search buffer, not just remove the highlight
noremap \c :let @/ = ""<CR>

"  Undo all local changes
nnoremap \r :e!<CR>

"  Insert the time!
nnoremap \ttt :execute "normal a" . strftime("%x %X (%Z)")<Esc>
inoremap \ttt <Esc>:execute "normal a" . strftime("%x %X (%Z)")<Esc>a

"  Remove dupes (sorts as well)
noremap \u :sort u<CR>:g/^$/d<CR>

"  Align on =>  (useful for hash assignments)
noremap \= :Align =><CR>

"  Copy the matches to a new buffer, remove the duplicates/blank lines, and copy to the clipboard
noremap \m :CopyMatches<CR>:tabnew<CR>"+p<CR>:sort u<CR>:g/^$/d<CR>:1,$y+<CR>

"  Uses perl to fix pretty much any date into a format Excel will actually parse :)
noremap \fd :silent! 1,$!perl -nMDateTime::Format::DateParse -E"BEGIN{sub fd{my $line = shift;chomp $line;my $dt = DateTime::Format::DateParse->parse_datetime($line, 'America/Chicago');$dt ? ($dt->set_time_zone('America/Chicago') and $dt->strftime('\%Y-\%m-\%d \%H:\%M:\%S')) : $line}; use Memoize; memoize 'fd'}say fd($_)"<CR>:norm \ca<CR>

"  Pastes and copies a bunch of text (to remove formatting)
noremap \fc :new<CR>"+p"+:1,$y+<CR>:bd!<CR>

"  Split the "databases" into their different parts
noremap \dbs :%s/\./\t/<CR>:%s/^\([^\t]\+\)\ze\t[^\t]\+$/\1\t\1<CR>

"  Diff functions
noremap \dn :tabnew<CR>:diffthis<CR>:vne<CR>:diffthis<CR>
noremap \dt :diffthis<CR>:vne<CR>:diffthis<CR>
noremap ,du :diffupdate<CR>

"  Toggle paste on/off
nnoremap \tp :set invpaste paste?<CR>

"  Toggle the display of "invisible" characters
nnoremap \tl :set invlist!<CR>

"  Copies everything into the clipboard
nnoremap \ca :1,$y+<CR>

"  Easy edit/sourcing of vimrc
nnoremap \s :source $MYVIMRC<CR>
nnoremap \v :tabnew $MYVIMRC<CR>

"  Shortcuts to save various "scratch" sessions
noremap \sa :SessionSaveAs scratcha<CR>
noremap \sb :SessionSaveAs scratchb<CR>
noremap \qs :SessionSaveAs quitscrach<CR>:qa!<CR>

"  Fix K&R style braces
noremap \fb mcHmt:g/^ *{ *$/norm kJ:s/ *{ *$/ {/<CR>:silent :noh<CR>'tzt`c


" -----------
" |  Comma  |
" -----------

"  Use relavent line numbers
noremap ,h :call g:ToggleNuMode()<CR>

"  Vertical split in a new buffer
noremap ,v :vne<CR>

"  Clear the q register and then begin recording to it (for recursive recordings)
noremap ,q  qqqqq

"  Copy the matches to the clipboard (slow?)
noremap ,m :CopyMatches<CR>

"  Remove dupes
noremap ,u :sort u<CR>:g/^$/d<CR>

"  Clear the (a)ll register
noremap ,a  qaq

"  Trim the domain from every line (abc => abc)  -- Is a little smart and doesn't clobber IPs
"  and such.  Also, tries to keep the trimming to the current word. Not tested as much as I'd like!!!
noremap ,t :%s/\(\<[a-zA-Z0-9_-]*[a-zA-Z][a-zA-Z0-9_-]*\)\.[a-zA-Z0-9_.-]*\>/\1/<CR>:silent noh<CR>

"  Takes all of the lines and formats them for a sql "IN" query part
noremap ,i :g/^$/d<CR>:%s/\v^(.*)$/   ,'\1'/<CR>:1s/   ,/(\r    <CR>:$s/$/\r)<CR>:silent noh<CR>"+:1,$y+<CR>

"  Shortcuts to save various "scratch" sessions
noremap ,sa :SessionOpen scratcha<CR>
noremap ,sb :SessionOpen scratchb<CR>
noremap ,qs :SessionOpen quitscrach<CR>

"  Close all of the open buffers (force close so be careful!)
noremap ,cab :tab sball<CR>:tabdo :bd!<CR>:tab sball<CR>:tabdo :bd!<CR>

"  CD to the current file directory
noremap ,cd :cd %:p:h<CR>

"  Seperate the lines by a newline if the first word isn't the first word on the following line
noremap ,sep :g/^\(\S\+\).\+\n\1\@!/s/$/\r<CR>:silent noh<CR>

"  Sorts the buffer and removes and line that isn't a duplicate (includes stupid hack to fix issue
"  I can't research right now)
noremap ,dupe :sort<CR>:g/^\(.\+\)\n\1\@!/d<CR>yyp:%s/^\(.\+\)\n\1\+/\1/<CR>:g/^$/d<CR>:silent noh<CR>

"  Shortcut to edit the conf files
noremap ,conf :tabnew $HOME/vimconfigs/

"  Split up args
noremap \fa :let b:l=matchend(getline('.'), '^ *')<CR>0f(a<CR><ESC>$F)i<CR><ESC>:s/^ */\=repeat(' ', b:l)<CR>k:s/,\zs */\r<CR>vibkV:s/^ */\=repeat(' ', b:l+4)<CR>:silent :noh<CR>

"  Pull out the usefull information in the monthly reports
noremap \md gg/^"*date<CR>"ayy:silent bufdo /^"*date/1,$y A<CR>:tabnew<CR>V"ap:g/^[^,]*,[^,]*$/s/,/,CISCO,Raw,/<CR>:%s/,/\t/e\|%s/^"*\(\w\+-\)\%(\d\d\)*\(\d\d\)"*\ze\t/\120\2/e\|%s/^"*\(\d\d\)-\(\w\+\)"*\ze\t/\2-20\1/e<CR>:2,$sort<CR>:nohlsearch<CR>:1,$y+<CR>

"  Turn the file menu on or off
nmap <silent> <C-F11> :if &guioptions=~'m' \| set guioptions-=m \| else \| set guioptions+=m \| endif<CR>

"  Fix network dumps of http traffic for easier analysis
noremap <silent> \fh :silent :CleanUpSourcefire<CR>

"  Clean up a lot of the IDs so it's easy to go through results
noremap <silent> \fid :silent %s/\<\%(\%(\%([ap]\\|sku\\|cjp\\|devicesku\\|skurep\\|product\%(category\)\?\\|category\)\?id\\|d\\|ref\\|loc\\|st\)=\\|pcmprd\\|_dynsessconf=\?\)\%(\%(ab\\|p\\|pcm\)\?cat\)\?-\?\d\+&\?//e \| silent sort u \| silent g/^\s*$/d<CR>
