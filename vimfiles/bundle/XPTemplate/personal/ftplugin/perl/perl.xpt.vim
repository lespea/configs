XPTemplate priority=personal

let s:f = g:XPTfuncs()

XPTvar $TRUE          1
XPTvar $FALSE         0
XPTvar $NULL
XPTvar $UNDEFINED

XPTvar $VOID_LINE     # void;
XPTvar $CURSOR_PH     # cursor

XPTvar $BRif          ' '
XPTvar $BRel   \n
XPTvar $BRloop        ' '
XPTvar $BRstc         ' '
XPTvar $BRfun         ' '

XPTinclude
      \ _common/common

XPTvar $CS #
XPTinclude
      \ _comment/singleSign

XPTvar $VAR_PRE    $
XPTvar $FOR_SCOPE  'my '
XPTinclude
      \ _loops/for

XPTinclude
      \ _loops/c.while.like


" ========================= Function and Variables =============================


" ================================= Snippets ===================================


" perl has no NULL value
XPT fornn hidden=1

XPT whilenn hidden=1


XPT perl " #!/usr/bin/env perl
#!/usr/bin/env perl

use strict;
use warnings;


..XPT


XPT xif " .. if ..;
`expr^  if  `cond^;


XPT xwhile " .. while ..;
`expr^  while  `cond^;


XPT xunless " .. unless ..;
`expr^  unless  `cond^;


XPT xforeach " .. foreach ..;
`expr^  foreach  @`array^;


XPT xfor " .. for ..;
`expr^  for  @`array^;

XPT try  "  Try::Tiny"
try {
    `expr^
}
`catch...{{^catch`$BRif^{
    `cursor^
}`}}^



XPT foreach " foreach my .. (..){}
foreach`$SPcmd^ my $`var^  (`$SParg^@`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT for " for my .. (..){}
for`$SPcmd^ my $`var^  (`$SParg^@`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT forkeys " foreach my var \( keys %** )
for`$SPcmd^ my $`var^  (`$SParg^keys %`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT forvalues " foreach my var \( keys %** )
for`$SPcmd^ my $`var^  (`$SParg^values %`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT moose "
use Moose;
use namespace::autoclean -also => qr/\^_/


`cursor^


__PACKAGE__->meta->make_immutable;
1;

..XPT



