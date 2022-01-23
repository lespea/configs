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
