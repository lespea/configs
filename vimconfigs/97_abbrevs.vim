" --------------------------------------
" |  Abbreviations and common re-maps  |
" --------------------------------------

"  My common f-ed up words
abb teh the
abb fo of
abb taht that
abb wehn when


"  Quote-words opporater in perl
inoremap qw/<SPACE>     qw/<SPACE><SPACE>/<Left><Left>
inoremap qw/;     qw/<SPACE><SPACE>/;<Left><Left><Left>
inoremap qw/<CR> qw/<CR>/;<Esc>O<Tab>

"  Quote-regex opporater in perl
inoremap qr{<CR> qr{<CR>}xms;<Esc>O<Tab>




"==================================================
"==                   DISABLED                   ==
"==================================================
"" 
"" "  My own special-isious brace completion (replace w/plugin?)
"" inoremap           (<SPACE>       ()<Left>
"" inoremap           ((             ()<Left>
"" inoremap           (;             ();<Left><Left>
"" inoremap  <expr>   )              strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
""        
"" inoremap           @{<SPACE>      @{  }<Left><Left>
"" inoremap           @{;            @{  };<Left><Left><Left>
""        
"" inoremap           %{<SPACE>      %{  }<Left><Left>
"" inoremap           %{;            %{  };<Left><Left><Left>
""        
"" inoremap           {<SPACE>       {}<Left>
"" inoremap           {{             {}<Left>
"" inoremap           {;             {};<Left><Left>
"" inoremap  <expr>   }              strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
""        
"" inoremap           [<SPACE>       []<Left>
"" inoremap           [[             []<Left>
"" inoremap           [;             [];<Left><Left>
"" inoremap  <expr>   ]              strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
""        
"" inoremap           {<CR>          {<CR>}<Esc>O
"" inoremap           (<CR>          (<CR>);<Esc>O
"" inoremap           /<CR>          /<CR>/;<Esc>O