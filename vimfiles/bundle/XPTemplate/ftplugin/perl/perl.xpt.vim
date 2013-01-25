XPTemplate priority=lang

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


XPT perl "Common perl header"
#!/usr/bin/env perl

use Modern::Perl qw/ 2011 /;

use autodie;
use autovivification;
use Const::Fast;
use Try::Tiny;


..XPT


XPT moose "Create a new localized moose package"
package `package^

use Moose;
use namespace::autoclean;

`cursor^

__PACKAGE__->meta->make_immutable;
1;


..XPT



XPT attr_counter "Creates a counter attribute that mimics a normal counter"
    has '`name^' => (
        is      => 'ro',
        isa     => 'Num',
        traits  => ['Counter'],
        default => 0,
        handles => {
            inc_`name^   => 'inc',
            dec_`name^   => 'dec',
            reset_`name^ => 'reset',
        },
    );


XPT attr_bool "Creates a bool attribute that mimics a normal bool"
    has '`name^' => (
        is      => 'ro',
        isa     => 'Num',
        traits  => ['Bool'],
        default => 0,
        handles => {
            not_`name^    => 'not',
            toggle_`name^ => 'toggle',
            set_`name^    => 'set',
            unset_`name^  => 'unset',
        },
    );


XPT attr_code "Creates a code attribute that mimics a normal code"
    has '`name^_cb' => (
        is      => 'ro',
        isa     => 'CodeRef',
        traits  => ['Code'],
        default => sub { sub {} },
        handles => {
            `name^ => 'execute',
        },
    );


XPT attr_num "Creates a number attribute that mimics a normal number"
    has '`name^' => (
        is      => 'ro',
        isa     => 'Num',
        traits  => ['Number'],
        default => 0,
        handles => {
            set_`name^ => 'set',
            add_`name^ => 'add',
            sub_`name^ => 'sub',
            mul_`name^ => 'mul',
            div_`name^ => 'div',
            mod_`name^ => 'mod',
            abs_`name^ => 'abs',
        },
    );


XPT attr_hash "Creates a hash attribute that mimics a normal hash"
    has '`name^' => (
        is      => 'ro',
        isa     => 'HashRef[`type^]',
        traits  => ['Hash'],
        default => sub {{}},
        handles => {
            `name^_ids            => 'keys',
            `name^_pairs          => 'kv',
            `name^_values         => 'values',
            clear_`name^`plural^  => 'clear',
            delete_`name^         => 'delete',
            get_`name^            => 'get',
            has_`name^            => 'exists',
            has_no_`name^`plural^ => 'is_empty',
            num_`name^`plural^    => 'count',
            set_`name^            => 'set',
        },
    );



XPT attr_array "Creates a array attribute that mimics a normal array"
    has '`name^' => (
        is      => 'ro',
        isa     => 'ArrayRef[`type^]',
        traits  => ['Array'],
        default => sub {[]},
        handles => {
            add_`name^                 => 'push',
            all_`name^`plural^         => 'elements',
            delete_`name^`plural^      => 'delete',
            filter_`name^`plural^      => 'grep',
            first_`name^`plural^       => 'first',
            first_index_`name^`plural^ => 'first_index',
            get_`name^                 => 'get',
            has_`name^`plural^         => 'count',
            has_no_`name^`plural^      => 'is_empty',
            insert_`name^`plural^      => 'insert',
            join_`name^`plural^        => 'join',
            map_`name^`plural^         => 'map',
            natatime_`name^`plural^    => 'natatime',
            pop_`name^`plural^         => 'pop',
            reduce_`name^`plural^      => 'reduce',
            set_`name^`plural^         => 'set',
            shift_`name^`plural^       => 'shift',
            shuffle_`name^`plural^     => 'shuffle',
            sorted_`name^`plural^      => 'sort',
            splice_`name^`plural^      => 'splice',
            uniq_`name^`plural^        => 'uniq',
            unshift_`name^`plural^     => 'unshift',
        },
    );


XPT csvn "New CSV wrtier"
my $`csv^ = Text::CSV_XS->new ({ binary => 1, eol => $/, quote_null => 0 }) or
    die 'Cannot use CSV: '.Text::CSV_XS->error_diag ();
`cursor^


XPT csvw "Write CSV line"
$`csv^->print($`fh^, `array_ref^)  or  die $`csv^->error_diag;
`cursor^


XPT csve "Check eof for CSV"
$`csv^->eof  or  die $`csv^->error_diag;
`cursor^


XPT csvr "Full CSV read"
open my $`fh^, "<:encoding(utf8)", $`in_file^;

`pre-condition^
while (my $row = $`csv^->getline($`fh^)) {
    my ($desc, $cidr) = @$row;
    `cursor^
}

$`csv^->eof  or  die $`csv^->error_diag;
close $`fh^;


XPT xif " .. if ..;
`expr^ if `cond^;


XPT xwhile " .. while ..;
`expr^ while `cond^;


XPT xunless " .. unless ..;
`expr^ unless `cond^;


XPT xforeach " .. foreach ..;
`expr^ foreach @`array^;


XPT sub " sub .. { .. }
sub `fun_name^`$BRfun^{
    `cursor^
}


XPT unless " unless ( .. ) { .. }
unless`$SPcmd^(`$SParg^`cond^`$SParg^)`$BRif^{
    `cursor^
}


XPT eval wrap=risky " eval { .. };if...
eval`$BRif^{
    `risky^
};
if`$SPcmd^(`$SParg^$@`$SParg^)`$BRif^{
    `handle^
}

XPT try alias=eval " eval { .. }; if ...


XPT whileeach " while \( \( key, val ) = each\( %** ) )
while`$SPcmd^(`$SParg^(`$SParg^$`key^,`$SPop^$`val^`$SParg^) = each(`$SParg^%`array^`$SParg^)`$SParg^)`$BRloop^{
    `cursor^
}

XPT whileline " while \( defined\( \$line = <FILE> ) )
while`$SPcmd^(`$SParg^defined(`$SParg^$`line^`$SPop^=`$SPop^<`STDIN^>`$SParg^)`$SParg^)`$BRloop^{
    `cursor^
}


XPT foreach " foreach my .. (..){}
foreach`$SPcmd^my $`var^ (`$SParg^@`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT forkeys " foreach my var \( keys %** )
foreach`$SPcmd^my $`var^ (`$SParg^keys @`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT forvalues " foreach my var \( keys %** )
foreach`$SPcmd^my $`var^ (`$SParg^values @`array^`$SParg^)`$BRloop^{
    `cursor^
}


XPT if wrap=job " if ( .. ) { .. } ...
XSET job=$CS job
if`$SPcmd^(`$SParg^`cond^`$SParg^)`$BRif^{
    `job^
}`
`elsif...^`$BRel^elsif`$SPcmd^(`$SParg^`cond2^`$SParg^)`$BRif^{
    `job^
}`
`elsif...^`
`else...{{^`$BRel^else`$BRif^{
    `cursor^
}`}}^

XPT package " 
package `className^;

use base qw(`parent^);

sub new`$BRfun^{
    my $class = shift;
    $class = ref $class if ref $class;
    my $self = bless {}, $class;
    $self;
}

1;

..XPT



