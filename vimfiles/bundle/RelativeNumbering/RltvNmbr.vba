" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/RltvNmbrPlugin.vim	[[[1
37
" RltvNmbr.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Aug 18, 2008
"   Version: 4a	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_RltvNmbrPlugin")
 finish
endif
let g:loaded_RltvNmbrPlugin = "v4a"
if !has("signs")
 echoerr 'Sorry, your vim is missing +signs; use  "configure --with-features=huge" , recompile, and install'
 finish
endif
let s:keepcpo= &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Public Interface: {{{1
com! -bang				RltvNmbr	call RltvNmbr#RltvNmbrCtrl(<bang>1)
silent! com -nargs=0	RN			call RltvNmbr#RltvNmbrToggle()

if has("gui_running") && has("menu") && &go =~ 'm'
 if !exists("g:DrChipTopLvlMenu")
  let g:DrChipTopLvlMenu= "DrChip."
 endif
 exe "menu ".g:DrChipTopLvlMenu."RltvNmbr.Start<tab>:RltvNmbr	:RltvNmbr<cr>"
endif
if !exists("b:rltvnmbrmode")
 let b:rltvnmbrmode= 0
endif

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
doc/RltvNmbr.txt	[[[1
116
*RltvNmbr.txt*	Relative Numbers			Mar 22, 2010

Author:  Charles E. Campbell, Jr.  <NdrOchip@ScampbellPfamily.AbizM>
	  (remove NOSPAM from Campbell's email first)
Copyright: (c) 2008-2009 by Charles E. Campbell, Jr.	*RltvNmbr-copyright*
           The VIM LICENSE applies to RltvNmbr.vim and RltvNmbr.txt
           (see |copyright|) except use "RltvNmbr instead of "Vim".
	   NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK.

==============================================================================
1. Contents				*RltvNmbr* *RltvNmbr-contents* {{{1

	1. Contents......................................: |RltvNmbr-contents|
	2. Relative Numbering Manual.....................: |RltvNmbr-manual|
	3. Relative Numbering History....................: |RltvNmbr-history|

==============================================================================
2. Relative Numbering Manual				*RltvNmbr-manual* {{{1

ENABLING AND DISABLING RELATIVE NUMBERING
    The Relative Numbering plugin provides a command: >
	:RltvNmbr[!]
<   The :RltvNmbr command enables relative numbering.
    The :RltvNmbr! command disables relative numbering.

							*RN*
    If :RN hasn't been previously defined, then one may also use >
	:RN
<   to toggle relative numbering.

    The RltvNumbr plugin reports on its enabled/disabled status with >
    	b:rltvnmbrmode=1 : RltvNmbr mode is enabled
    	b:rltvnmbrmode=0 : RltvNmbr mode is disabled
<    This variable is used for reporting and to control :RN based toggling.

YOUR VIM MUST HAVE SIGNS FOR THIS PLUGIN
    To use this plugin your vim must have been compiled with the "huge" feature
    set (so as to have +signs in the :version listing).  Typically that means
    having used >
	configure --with-features=huge
<
    To determine if your copy of vim has signs, you may: >
    	:echo has("signs")
<   If it shows "1", then your vim supports signs.

    Alternatively, you may: >
	:version
<   and if +signs appears in the listing, then, again, your vim supports
    signs.  If it lists -signs, then unfortunately your vim does not do so.

MODFIYING THE RELATIVE NUMBERING HIGHLIGHTING
    The relative numbering signs are highlighted with >

	hi default HL_RltvNmbr_Minus    gui=none,italic ctermfg=red   ctermbg=black guifg=red   guibg=black
	hi default HL_RltvNmbr_Positive	gui=none,italic ctermfg=green ctermbg=black guifg=green guibg=black

<   This information is provided so that you may know what to specify to use
    your preferences in relative number highlighting.  One way to get your
    preferred colorization in is to put lines like the following into
    .vim/after/plugin/RltvNmbr.vim: >

	au FileType * hi HL_RltvNmbr_Minus    gui=none ctermfg=yellow  ctermbg=black guifg=yellow  guibg=black
	au FileType * hi HL_RltvNmbr_Positive gui=none ctermfg=magenta ctermbg=black guifg=magenta guibg=black
<

HOW TO START WITH RELATIVE NUMBERING MODE ENABLED
   Using >
   	Unix: ~/.vim/after/plugin/RltvNmbr.vim
	Windows: $HOME\_vimfiles\after\plugin\RltvNmbr.vim
<  place the following line: >
	call RltvNmbr#RltvNmbrCtrl(1)
<
THE RELATIVE NUMBERING PATCH
    This plugin was inspired by the relative-numbering patch mentioned on the
    vim-dev mailing list, written by Markus Heidelberg.  You can find his patch at

http://groups.google.com/group/vim_dev/attach/10fa0944a8b643b4/vim-7.2-relativenumber-02.patch?part=2

    This plugin uses signs to enable relative numbering.  Signs are assigned
    on a buffer-by-buffer basis as an inherent limitation, so a given buffer
    can only display one set of signs.  The relative numbering patch does not
    have this limitation.  To see this effect, try using >
    	vim -O file file
<   and use relative numbering provided by this plugin.  You'll find that the
    relative numbering column will change as you switch windows to reflect
    your active cursor.


==============================================================================
3. Relative Numbering History				*RltvNmbr-history* {{{1
	4: Mar 22, 2010		* (bugfix) relative numbering improperly updated
				  when a line was deleted.
	3: Aug 22, 2008		* speeded up unplacing of signs
				* included g:rltvnmbrmode to report en/dis-abled
				* s:AvoidOtherSigns() written/included to
				* allow RltvNmbr() to avoid using previously
				  existing sign IDs.
				* included some more autocmds for rltv nmbr
				  updating
   	2: Aug 19, 2008		* included :RN command which toggles
	   			  relative numbering
				* included some more autocmds to update
				  relative numbering.
				* made gvim's version use italic numbers
				* :RN was toggling globally; now its done
				  on a buffer-by-buffer basis.
				* Included DrChip menu support for gvim use
	1: Aug 18, 2008		* Initial release
	   Aug 18, 2008		* Fixed some bugs associated with folding
	   Aug 18, 2008		* Changes in colorscheme was clearing the
	   			  highlighting.  Highlighting now restored.

==============================================================================
Modelines: {{{1
vim:tw=78:ts=8:ft=help:fdm=marker:

autoload/RltvNmbr.vim	[[[1
281
" RltvNmbr.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Mar 22, 2010
"   Version: 4a	ASTRO-ONLY
"   GetLatestVimScripts: 2351 1 :AutoInstall: RltvNmbr.vim
"   Phillippians 1:27 :  Only let your manner of life be worthy of the gospel of
"     Christ, that, whether I come and see you or am absent, I may hear of
"     your state, that you stand firm in one spirit, with one soul striving
"     for the faith of the gospel
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_RltvNmbr")
 finish
endif
let g:loaded_RltvNmbr = "v4a"
if v:version < 700
 echohl WarningMsg
 echo "***warning*** this version of RltvNmbr needs vim 7.0"
 echohl Normal
 finish
endif
if !has("signs")
 echoerr 'Sorry, your vim is missing +signs; use  "configure --with-features=huge" , recompile, and install'
 finish
endif
if !has("syntax")
 echoerr 'Sorry, your vim is missing +syntax; use  "configure --with-features=huge" , recompile, and install'
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
"DechoTabOn

" ---------------------------------------------------------------------
"  Parameters: {{{1
let s:RLTVNMBR= 2683
if !exists("g:DrChipTopLvlMenu")
 let g:DrChipTopLvlMenu= "DrChip."
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" RltvNmbr: {{{2
fun! s:RltvNmbr(mode,...)
"  call Dfunc("s:RltvNmbr(mode=".a:mode.((a:0 > 0)? " ".a:1.")" : ")"))

  if a:mode == 1
   " initial placement of signs
"   call Decho("mode ".a:mode.": initial sign placement")
   let wt = line("w0") " window top line
   let wc = line(".")  " window current line
   let wb = line("w$") " window bottom line
   let fb = line("$")  " file bottom line
"   call Decho("initial placement of signs: wt=".wt." wc=".wc." wb=".wb." fb=".fb)
   let w                                = wt
   let s:rltvnmbr_topline_{bufnr("%")}  = wt
   let s:rltvnmbr_curline_{bufnr("%")}  = wc
   let s:rltvnmbr_wbotline_{bufnr("%")} = wb
   let s:rltvnmbr_botline_{bufnr("%")}  = fb
"   call Decho("init s:rltvnmbr_curline_".bufnr("%")."=".s:rltvnmbr_curline_{bufnr("%")})
"   call Decho("init s:rltvnmbr_topline_".bufnr("%")."=".s:rltvnmbr_topline_{bufnr("%")})
"   call Decho("init s:rltvnmbr_wbotline_".bufnr("%")."=".s:rltvnmbr_wbotline_{bufnr("%")})
"   call Decho("init s:rltvnmbr_botline_".bufnr("%")."=".s:rltvnmbr_botline_{bufnr("%")})
   while w <= wb
	if w == wc
	 let w= w + 1
	 continue
	endif
	let wmwc = w - wc
	if foldclosed(w) != -1
"	 call Decho("skipping w=".w." wmwc=".wmwc." foldclosed=".foldclosed(w))
	 let w= foldclosedend(w)+1
	 continue
	endif
	if wmwc <= -100
	 let w= wc - 99
	 continue
	endif
	if wmwc >= 100
	 break
	endif
	if wmwc < 0
	 let name = "RLTVN_M".(-wmwc)
	 exe "sign place ".(s:RLTVNMBR + wmwc)." line=".w." name=".name." buffer=".bufnr("%")
	else
	 let name = "RLTVN_P".wmwc
	 exe "sign place ".(s:RLTVNMBR + wmwc)." line=".w." name=".name." buffer=".bufnr("%")
	endif
	let w= w + 1
   endwhile

  elseif a:mode == 2
"   call Decho("mode ".a:mode.": consider removing and placing signs")
   if exists("s:rltvnmbr_curline_{bufnr('%')}")
"	call Decho("line(.)=".line("."))
"	call Decho("s:rltvnmbr_curline_".bufnr("%")."=".s:rltvnmbr_curline_{bufnr("%")})
"	call Decho("line(w0)=".line("w0"))
"	call Decho("s:rltvnmbr_topline_".bufnr("%")."=".s:rltvnmbr_topline_{bufnr("%")})
"	call Decho("line(w$)=".line("w$"))
"	call Decho("s:rltvnmbr_wbotline_".bufnr("%")."=".s:rltvnmbr_wbotline_{bufnr("%")})
"	call Decho("line($)=".line("$"))
"	call Decho("s:rltvnmbr_botline_".bufnr("%")."=".s:rltvnmbr_botline_{bufnr("%")})
    " remove and place signs
	if line(".") != s:rltvnmbr_curline_{bufnr("%")} || line("w0") != s:rltvnmbr_topline_{bufnr("%")} || line("w$") != s:rltvnmbr_wbotline_{bufnr("%")} || line("$") != s:rltvnmbr_botline_{bufnr("%")}
"	 call Decho("do remove&place signs : (".line(".").",".line("w0").") =?= (".s:rltvnmbr_curline_{bufnr("%")}.",".s:rltvnmbr_topline_{bufnr("%")}.")")
     exe "sign place ".s:RLTVNMBR." line=".s:rltvnmbr_curline_{bufnr("%")}." name=RLTVCURID buffer=".bufnr("%")
     let lzkeep= &lz
	 set lz
     call s:RltvNmbr(3)  " remove signs
     call s:RltvNmbr(1)  " place signs
     exe "sign unplace ".s:RLTVNMBR." buffer=".bufnr("%")
     let &lz= lzkeep
    endif
   endif

  elseif a:mode == 3
   " removal of signs
"   call Decho("mode ".a:mode.": removal of signs")
   let wt = s:rltvnmbr_topline_{bufnr("%")}
   let wc = s:rltvnmbr_curline_{bufnr("%")}
   let wb = s:rltvnmbr_wbotline_{bufnr("%")}
   let fb = s:rltvnmbr_botline_{bufnr("%")}
"   call Decho("using s:wt=".wt." s:wc=".wc." s:wb=".wb." s:fb=".fb)
   let w  = wt
   while w <= wb
	if w == wc
	 let w= w + 1
	 continue
	endif
	let wmwc = w - wc
	if foldclosed(w) != -1
"	 call Decho("skipping w=".w." wmwc=".wmwc." foldclosed=".foldclosed(w))
	 let w= foldclosedend(w)+1
	 continue
	endif
	if wmwc <= -100
	 let w= wc - 99
	 continue
	endif
	if wmwc >= 100
	 break
	endif
	if wmwc < 0
	 let name= "RLTVN_M".(-wmwc)
	else
	 let name= "RLTVN_P".wmwc
	endif
	exe "sign unplace ".(s:RLTVNMBR + wmwc)." buffer=".bufnr("%")
	let w= w + 1
   endwhile

  else
   echoerr "mode=".a:mode." unsupported"
  endif

"  call Dret("s:RltvNmbr")
endfun

" ---------------------------------------------------------------------
" RltvNmbr#RltvNmbrCtrl: {{{2
fun! RltvNmbr#RltvNmbrCtrl(start)
"  call Dfunc("RltvNmbr#RltvNmbrCtrl(start=".a:start.")")

  if      a:start && !exists("s:rltvnmbr_{bufnr('%')}")
   let s:rltvnmbr_{bufnr("%")}= 1
   let b:rltvnmbrmode         = 1

   if !exists("s:rltvnmbr_signs")
	let s:rltvnmbr_signs= 1
	hi default HL_RltvNmbr_Minus	gui=none,italic ctermfg=red   ctermbg=black guifg=red   guibg=black
	hi default HL_RltvNmbr_Positive	gui=none,italic ctermfg=green ctermbg=black guifg=green guibg=black
	silent call s:AvoidOtherSigns()
    let L= 1
    while L <= 99
	 exe "sign define RLTVN_M".L.' text='.string(L).' texthl=HL_RltvNmbr_Minus'
	 exe "sign define RLTVN_P".L.' text='.string(L).' texthl=HL_RltvNmbr_Positive'
     let L= L+1
    endwhile
   endif
   sign define RLTVCURID text=-- texthl=Ignore

   exe "menu ".g:DrChipTopLvlMenu."RltvNmbr.Stop<tab>:RltvNmbr!	:RltvNmbr!<cr>"
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'RltvNmbr.Start'
   call s:RltvNmbr(1)
"   call Decho("set up all RltvNmbrAutoCmd automcmds")
   augroup RltvNmbrAutoCmd
	au!
    au CursorHold           * call <SID>RltvNmbr(2,"cursorhold")
	au CursorMoved          * call <SID>RltvNmbr(2,"cursormoved")
	au FileChangedShellPost * call <SID>RltvNmbr(2,"filechangedshellpost")
	au FocusGained          * call <SID>RltvNmbr(2,"focusgained")
	au FocusLost            * call <SID>RltvNmbr(2,"focuslost")
	au InsertEnter          * call <SID>RltvNmbr(2,"insertenter")
	au ShellCmdPost         * call <SID>RltvNmbr(2,"shellcmdpost")
	au ShellFilterPost      * call <SID>RltvNmbr(2,"shellfilterpost")
	au TabEnter             * call <SID>RltvNmbr(2,"tabenter")
	au VimResized           * call <SID>RltvNmbr(2,"vimresized")
	au WinEnter             * call <SID>RltvNmbr(2,"winenter")
    au ColorScheme          * call <SID>ColorschemeLoaded()
   augroup END

  elseif !a:start && exists("s:rltvnmbr_{bufnr('%')}")
   let b:rltvnmbrmode         = 0
   unlet s:rltvnmbr_{bufnr("%")}
"   call Decho("clear all autocmds from RltvNmbrAutoCmd group")
   augroup RltvNmbrAutoCmd
	au!
   augroup END
   augroup! RltvNmbrAutoCmd
   call s:RltvNmbr(3)
   exe "sign unplace ".s:RLTVNMBR." buffer=".bufnr("%")
   exe "menu ".g:DrChipTopLvlMenu."RltvNmbr.Start<tab>:RltvNmbr	:RltvNmbr<cr>"
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'RltvNmbr.Stop'

  else
   echo "RltvNmbr is already ".((a:start)? "enabled" : "off")
  endif
"  call Dret("RltvNmbr#RltvNmbrCtrl")
endfun

" ---------------------------------------------------------------------
" RltvNmbr#RltvNmbrToggle: supports the :RN command for quick relative-number-mode toggling {{{2
"                          If the :RN command is already available, then it will not be overridden.
fun! RltvNmbr#RltvNmbrToggle()
"  call Dfunc("RltvNmbr#RltvNmbrToggle()")
  
  if !exists("b:rltvnmbrmode")
   let b:rltvnmbrmode= 0
  endif
  if b:rltvnmbrmode == 0
   RltvNmbr
  else
   RltvNmbr!
  endif

"  call Dret("RltvNmbr#RltvNmbrToggle")
endfun

" ---------------------------------------------------------------------
" s:ColorschemeLoaded: {{{2
fun! s:ColorschemeLoaded()
"  call Dfunc("s:ColorschemeLoaded()")
	hi HL_RltvNmbr_Minus	ctermfg=red   ctermbg=black guifg=red   guibg=black
	hi HL_RltvNmbr_Positive	ctermfg=green ctermbg=black guifg=green guibg=black
"  call Dret("s:ColorschemeLoaded")
endfun

" ---------------------------------------------------------------------
" s:AvoidOtherSigns: {{{2
fun! s:AvoidOtherSigns()
"  call Dfunc("s:AvoidOtherSigns()")
  if !exists("s:othersigns")
   " only do this one time
   redir => s:othersigns
    sign place
   redir END
   " determine the max id being used and use one more than that as the beginning of RltvNmbr ids
   let signlist= split(s:othersigns,'\n')
   let idlist  = map(signlist,"substitute(v:val,'^.\\{-}\\<id=\\(\\d\\+\\)\\s.*$','\\1','')")
   if len(idlist) > 2
    let idlist = remove(idlist,2,-1)
    let idlist = map(idlist,"str2nr(v:val)")
    let idmax  = max(idlist)
	if idmax > s:RLTVNMBR
	 let s:RLTVNMBR = idmax + 1
"     call Decho("s:RLTVNMBR=".s:RLTVNMBR)
	endif
   endif
   unlet s:othersigns
   let s:othersigns= 1
   endif
"  call Dret("s:AvoidOtherSigns : s:RLTVNMBR=".s:RLTVNMBR)
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
