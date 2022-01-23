" -----------------------------------------------------
" |  A bunch of custom functions (mostly from forums  |
" -----------------------------------------------------


" --------------------
" |  Swap two lines  |
" --------------------

function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap  <silent> <C-S-UP>   :call <SID>swap_up()<CR>
noremap  <silent> <C-S-DOWN> :call <SID>swap_down()<CR>


" -----------------
" |  CopyMatches  |
" -----------------

" Copy matches of the last search to a register (default is the clipboard).
" Accepts a range (default is whole file).
" 'CopyMatches'   copies matches to clipboard (each match has \n added).
" 'CopyMatches x' copies matches to register x (clears register first).
" 'CopyMatches X' appends matches to register x.
command! -range=% -register CopyMatches call s:CopyMatches(<line1>, <line2>, '<reg>')
function! s:CopyMatches(line1, line2, reg)
  let reg = empty(a:reg) ? '+' : a:reg
  if reg =~# '[A-Z]'
    let reg = tolower(reg)
  else
    execute 'let @'.reg.' = ""'
  endif
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      execute 'let @'.reg.' .= matchstr(txt, @/, idx) . "\n"'
      let end = matchend(txt, @/, idx)
      let idx = match(txt, @/, end)
    endwhile
  endfor
endfunction


" -----------------
" |  CopyMatches  |
" -----------------

" Clears whitespace at the end of every line w/cleanup
" Strips the trailing whitespace from a file
function! s:StripTrailingWhitespaces()
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
command! -range=% -register StripTrailingWhitespaces call s:StripTrailingWhitespaces()



" --------------------------
" |  FixSourcefireTraffic  |
" --------------------------

"  Stolen from unimpaired since they're private functions; don't think I can call them?
function! s:UrlDecode(str)
  let str = substitute(substitute(substitute(a:str,'%0[Aa]\n$','%0A',''),'%0[Aa]','\n','g'),'+',' ','g')
  return substitute(str,'%\(\x\x\)','\=nr2char("0x".submatch(1))','g')
endfunction

let s:unimpaired_html_entities = {
      \ 'nbsp':     160, 'iexcl':    161, 'cent':     162, 'pound':    163,
      \ 'curren':   164, 'yen':      165, 'brvbar':   166, 'sect':     167,
      \ 'uml':      168, 'copy':     169, 'ordf':     170, 'laquo':    171,
      \ 'not':      172, 'shy':      173, 'reg':      174, 'macr':     175,
      \ 'deg':      176, 'plusmn':   177, 'sup2':     178, 'sup3':     179,
      \ 'acute':    180, 'micro':    181, 'para':     182, 'middot':   183,
      \ 'cedil':    184, 'sup1':     185, 'ordm':     186, 'raquo':    187,
      \ 'frac14':   188, 'frac12':   189, 'frac34':   190, 'iquest':   191,
      \ 'Agrave':   192, 'Aacute':   193, 'Acirc':    194, 'Atilde':   195,
      \ 'Auml':     196, 'Aring':    197, 'AElig':    198, 'Ccedil':   199,
      \ 'Egrave':   200, 'Eacute':   201, 'Ecirc':    202, 'Euml':     203,
      \ 'Igrave':   204, 'Iacute':   205, 'Icirc':    206, 'Iuml':     207,
      \ 'ETH':      208, 'Ntilde':   209, 'Ograve':   210, 'Oacute':   211,
      \ 'Ocirc':    212, 'Otilde':   213, 'Ouml':     214, 'times':    215,
      \ 'Oslash':   216, 'Ugrave':   217, 'Uacute':   218, 'Ucirc':    219,
      \ 'Uuml':     220, 'Yacute':   221, 'THORN':    222, 'szlig':    223,
      \ 'agrave':   224, 'aacute':   225, 'acirc':    226, 'atilde':   227,
      \ 'auml':     228, 'aring':    229, 'aelig':    230, 'ccedil':   231,
      \ 'egrave':   232, 'eacute':   233, 'ecirc':    234, 'euml':     235,
      \ 'igrave':   236, 'iacute':   237, 'icirc':    238, 'iuml':     239,
      \ 'eth':      240, 'ntilde':   241, 'ograve':   242, 'oacute':   243,
      \ 'ocirc':    244, 'otilde':   245, 'ouml':     246, 'divide':   247,
      \ 'oslash':   248, 'ugrave':   249, 'uacute':   250, 'ucirc':    251,
      \ 'uuml':     252, 'yacute':   253, 'thorn':    254, 'yuml':     255,
      \ 'OElig':    338, 'oelig':    339, 'Scaron':   352, 'scaron':   353,
      \ 'Yuml':     376, 'circ':     710, 'tilde':    732, 'ensp':    8194,
      \ 'emsp':    8195, 'thinsp':  8201, 'zwnj':    8204, 'zwj':     8205,
      \ 'lrm':     8206, 'rlm':     8207, 'ndash':   8211, 'mdash':   8212,
      \ 'lsquo':   8216, 'rsquo':   8217, 'sbquo':   8218, 'ldquo':   8220,
      \ 'rdquo':   8221, 'bdquo':   8222, 'dagger':  8224, 'Dagger':  8225,
      \ 'permil':  8240, 'lsaquo':  8249, 'rsaquo':  8250, 'euro':    8364,
      \ 'fnof':     402, 'Alpha':    913, 'Beta':     914, 'Gamma':    915,
      \ 'Delta':    916, 'Epsilon':  917, 'Zeta':     918, 'Eta':      919,
      \ 'Theta':    920, 'Iota':     921, 'Kappa':    922, 'Lambda':   923,
      \ 'Mu':       924, 'Nu':       925, 'Xi':       926, 'Omicron':  927,
      \ 'Pi':       928, 'Rho':      929, 'Sigma':    931, 'Tau':      932,
      \ 'Upsilon':  933, 'Phi':      934, 'Chi':      935, 'Psi':      936,
      \ 'Omega':    937, 'alpha':    945, 'beta':     946, 'gamma':    947,
      \ 'delta':    948, 'epsilon':  949, 'zeta':     950, 'eta':      951,
      \ 'theta':    952, 'iota':     953, 'kappa':    954, 'lambda':   955,
      \ 'mu':       956, 'nu':       957, 'xi':       958, 'omicron':  959,
      \ 'pi':       960, 'rho':      961, 'sigmaf':   962, 'sigma':    963,
      \ 'tau':      964, 'upsilon':  965, 'phi':      966, 'chi':      967,
      \ 'psi':      968, 'omega':    969, 'thetasym': 977, 'upsih':    978,
      \ 'piv':      982, 'bull':    8226, 'hellip':  8230, 'prime':   8242,
      \ 'Prime':   8243, 'oline':   8254, 'frasl':   8260, 'weierp':  8472,
      \ 'image':   8465, 'real':    8476, 'trade':   8482, 'alefsym': 8501,
      \ 'larr':    8592, 'uarr':    8593, 'rarr':    8594, 'darr':    8595,
      \ 'harr':    8596, 'crarr':   8629, 'lArr':    8656, 'uArr':    8657,
      \ 'rArr':    8658, 'dArr':    8659, 'hArr':    8660, 'forall':  8704,
      \ 'part':    8706, 'exist':   8707, 'empty':   8709, 'nabla':   8711,
      \ 'isin':    8712, 'notin':   8713, 'ni':      8715, 'prod':    8719,
      \ 'sum':     8721, 'minus':   8722, 'lowast':  8727, 'radic':   8730,
      \ 'prop':    8733, 'infin':   8734, 'ang':     8736, 'and':     8743,
      \ 'or':      8744, 'cap':     8745, 'cup':     8746, 'int':     8747,
      \ 'there4':  8756, 'sim':     8764, 'cong':    8773, 'asymp':   8776,
      \ 'ne':      8800, 'equiv':   8801, 'le':      8804, 'ge':      8805,
      \ 'sub':     8834, 'sup':     8835, 'nsub':    8836, 'sube':    8838,
      \ 'supe':    8839, 'oplus':   8853, 'otimes':  8855, 'perp':    8869,
      \ 'sdot':    8901, 'lceil':   8968, 'rceil':   8969, 'lfloor':  8970,
      \ 'rfloor':  8971, 'lang':    9001, 'rang':    9002, 'loz':     9674,
      \ 'spades':  9824, 'clubs':   9827, 'hearts':  9829, 'diams':   9830,
      \ 'apos':      39}

function! s:XmlEntityDecode(str)
  let str = substitute(a:str,'\c&#\%(0*38\|x0*26\);','&amp;','g')
  let str = substitute(str,'\c&#\(\d\+\);','\=nr2char(submatch(1))','g')
  let str = substitute(str,'\c&#\(x\x\+\);','\=nr2char("0".submatch(1))','g')
  let str = substitute(str,'\c&apos;',"'",'g')
  let str = substitute(str,'\c&quot;','"','g')
  let str = substitute(str,'\c&gt;','>','g')
  let str = substitute(str,'\c&lt;','<','g')
  let str = substitute(str,'\C&\(\%(amp;\)\@!\w*\);','\=nr2char(get(g:unimpaired_html_entities,submatch(1),63))','g')
  return substitute(str,'\c&amp;','\&','g')
endfunction



function! s:AlignChar( char, list )
    let list = a:list
    let char = a:char

    let maxLen = max( map( copy(list), 'match(v:val, "' . char . '")' ) )
    let fixedLines = []

    for line in list
        let thisLen = match(line, char)
        let replStr = repeat(' ', (maxLen - thisLen) + 1)
        call add( fixedLines, substitute(line, '^[^' . char . ']\+\zs' . char . '\s*', replStr . char . ' ', '') )
    endfor

    return fixedLines
endfunction



function! s:CleanURL( URL )
    let decoded    = s:UrlDecode(substitute(a:URL, '\&amp;', '\&', 'g'))
    let tmpDecoded = s:UrlDecode(substitute(decoded, '\&amp;', '\&', 'g'))

    while decoded != tmpDecoded
        let decoded    = tmpDecoded
        let tmpDecoded = s:UrlDecode(substitute(decoded, '\&amp;', '\&', 'g'))
    endwhile

    let [target; params] = split( decoded, '\ze[?&;]' )
    let rtn = s:AlignChar( '=', map( params, 'substitute( v:val, ''^\(.\)'', ''    \1 '', "")' ) )
    return ['    ' . target, ''] + rtn
endfunction



function! s:CleanLine( line )
    let line = a:line
    let httpCommands    = ['POST', 'PUT', 'GET']

    let allHttpCommands = join(httpCommands, '\|')
    let httpParser      = '^.\{-}\('  . allHttpCommands . '\)\s*\(.\{-}\)\s*\(HTTP/1\.[10]\)\(.\{-}\)\s*$'

    let tmpLines = []

    if match( line, httpParser ) >= 0
        let parts = matchlist( line, httpParser )

        "  Add the action
        call add( tmpLines, parts[1] )

        "  Add the request url
        call extend( tmpLines, s:CleanURL( parts[2] ) )

        "  Add the http type
        call add( tmpLines, '  ' . parts[3] )

        "  Process the rest
        let rest = parts[4]

        "  Trim the string (including newlines still in txt form)
        let rest = substitute( rest, '^\%(\\r\\n\)\+\s*\|\s*\%(\\r\\n\)\+\$', '', 'g' )

        "  Split on the txt newlinesj
        let restLines = s:AlignChar( ':', split( rest, '\s*\%(\\r\\n\)\+\s*' ) )

        "  Loop through the remaining lines, fix up if necessary, and add to the return array
        for restLine in restLines
            if restLine =~ '^Cookie'
                let [cookieStr; cookies] = map( split( restLine, '\%(^Cookie\zs:\|;\) \+' ), '"    " . v:val' )
                call add( tmpLines, 'Cookies:' )
                call extend( tmpLines, s:AlignChar( '=', cookies) )
            else
                if restLine =~ '/^Referer:/'
                    call add( tmpLines, s:UrlDecode(restLine) )
                else
                    call add( tmpLines, restLine )
                endif
            endif
        endfor
    elseif line != ''
        call add( tmpLines, line )
    endif

    return tmpLines
endfunction



" The sourcefire packets exported from the logger are a mess, this cleans them up!
function! s:CleanUpSourcefire()
    let spacerStr = repeat( '*-', 60 )
    let spacer = ['', '', '', spacerStr, '', '', '']

    let allLines = getline(1, '$')

    let curLine = 1
    let firstItem = 1
    for line in allLines
        let cleanedLines = s:CleanLine( line )

        if len(cleanedLines) > 0
            if !firstItem
                call setline( curLine, spacer )
                let curLine = curLine + len( spacer )
            else
                let firstItem = 0
            endif

            call setline( curLine, cleanedLines )
            let curLine = curLine + len( cleanedLines )
        endif
    endfor
endfunction
command! -register CleanUpSourcefire call s:CleanUpSourcefire()
