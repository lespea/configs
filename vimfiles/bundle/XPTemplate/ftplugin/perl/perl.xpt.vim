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


XPT plog "Setup logging"
use Log::Log4perl qw/ get_logger /;
BEGIN {
    my $DEBUG    = `debug_option^;
    my $LOG_FILE = `log_to_file_option^;

    my $LOG_LEVEL_STR = sprintf '%s, %s',
        ($DEBUG    ? 'DEBUG' : 'INFO'),
        ($LOG_FILE ? 'Logfile, ' : q{}) . 'Screen';

    #########################
    #  Module Base Logging  #
    #########################
    my $LOG4PERL_CONF = {
        'log4perl.rootLogger'                                => $LOG_LEVEL_STR,

        'log4perl.appender.Logfile'                          => 'Log::Log4perl::Appender::File',
        'log4perl.appender.Logfile.filename'                 => '`debug^.log',
        'log4perl.appender.Logfile.utf8'                     => '1',
        'log4perl.appender.Logfile.layout'                   => 'Log::Log4perl::Layout::PatternLayout',
        'log4perl.appender.Logfile.mode'                     => 'append',
        'log4perl.appender.Logfile.layout.ConversionPattern' => '%p [%d] (%r) %M:%L :: %m{chomp}%n',

        'log4perl.appender.Screen'                           => 'Log::Log4perl::Appender::Screen',
        'log4perl.appender.Screen.stderr'                    => '0',
        'log4perl.appender.Screen.layout'                    => 'Log::Log4perl::Layout::SimpleLayout',
    };

    Log::Log4perl->init_once( $LOG4PERL_CONF );
}
my $logger = get_logger();

..XPT

XPT perl "Common perl header"
#!/usr/bin/env perl

use Modern::Perl qw/ 2011 /;

use autodie;
use autovivification;
use Const::Fast;
use Try::Tiny;


..XPT


XPT moose "Create a new localized moose package"
package `package^;
    use Moose;
    use namespace::autoclean;

    with 'MooseX::Log::Log4perl';

    `cursor^

    __PACKAGE__->meta->make_immutable;
    1;


..XPT


XPT m_sattr "Create a small generic moose attribute"
has '`name^' => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    lazy      => 0,
    default   => '',
    init_arg  => undef,
);


XPT m_attr "Create a generic moose attribute"
has '`name^' => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    default   => '',
    lazy      => 1,
    builder   => 'build_`name^',
    clearer   => 'clear_`name^',
    predicate => 'has_`name^',
    init_arg  => undef,
);


XPT m_trigger "Add a trigger to an attribute"
trigger => sub {
    `code^
},


XPT attr_counter "Creates a counter attribute that mimics a normal counter"
has '`attr_name^' => (
    is        => 'ro',
    isa       => 'Num',
    traits    => ['Counter'],
    default   => 0,
    lazy      => 1,
    required  => 1,
    handles   => {
        inc_`trait_name^   => 'inc',
        dec_`trait_name^   => 'dec',
        reset_`trait_name^ => 'reset',
    },
);


XPT attr_bool "Creates a bool attribute that mimics a normal bool"
has '`attr_name^' => (
    is        => 'ro',
    isa       => 'Num',
    traits    => ['Bool'],
    default   => 0,
    lazy      => 1,
    required  => 1,
    handles   => {
        not_`trait_name^    => 'not',
        toggle_`trait_name^ => 'toggle',
        set_`trait_name^    => 'set',
        unset_`trait_name^  => 'unset',
    },
);


XPT attr_code "Creates a code attribute that mimics a normal code"
has '`attr_name^_cb' => (
    is        => 'ro',
    isa       => 'CodeRef',
    traits    => ['Code'],
    default   => sub { sub {} },
    lazy      => 1,
    required  => 1,
    handles   => {
        `trait_name^ => 'execute',
    },
);


XPT attr_num "Creates a number attribute that mimics a normal number"
has '`attr_name^' => (
    is        => 'ro',
    isa       => 'Num',
    traits    => ['Number'],
    default   => 0,
    lazy      => 1,
    required  => 1,
    handles   => {
        set_`trait_name^ => 'set',
        add_`trait_name^ => 'add',
        sub_`trait_name^ => 'sub',
        mul_`trait_name^ => 'mul',
        div_`trait_name^ => 'div',
        mod_`trait_name^ => 'mod',
        abs_`trait_name^ => 'abs',
    },
);


XPT attr_hash "Creates a hash attribute that mimics a normal hash"
has '`attr_name^' => (
    is        => 'ro',
    isa       => 'HashRef[`type^]',
    traits    => ['Hash'],
    default   => sub {{}},
    lazy      => 1,
    required  => 1,
    handles   => {
        `trait_name^_keys           => 'keys',
        `trait_name^_pairs          => 'kv',
        `trait_name^_values         => 'values',
        clear_`trait_name^`plural^  => 'clear',
        delete_`trait_name^         => 'delete',
        get_`trait_name^            => 'get',
        has_`trait_name^            => 'exists',
        has_no_`trait_name^`plural^ => 'is_empty',
        num_`trait_name^`plural^    => 'count',
        set_`trait_name^            => 'set',
    },
);


XPT attr_array "Creates a array attribute that mimics a normal array"
has '`attr_name^' => (
    is        => 'ro',
    isa       => 'ArrayRef[`type^]',
    traits    => ['Array'],
    default   => sub {[]},
    lazy      => 1,
    required  => 1,
    handles   => {
        `name^_elements         => 'elements',
        add_`name^              => 'push',
        clear_`name^`plural^    => 'clear',
        delete_`name^`plural^   => 'delete',
        filter_`name^`plural^   => 'grep',
        first_`name^            => 'first',
        first_`name^_index      => 'first_index',
        get_`name^              => 'get',
        has_`name^`plural^      => 'count',
        has_no_`name^`plural^   => 'is_empty',
        insert_`name^`plural^   => 'insert',
        join_`name^`plural^     => 'join',
        map_`name^`plural^      => 'map',
        natatime_`name^`plural^ => 'natatime',
        num_`name^`plural^      => 'count',
        pop_`name^`plural^      => 'pop',
        reduce_`name^`plural^   => 'reduce',
        set_`name^`plural^      => 'set',
        shift_`name^`plural^    => 'shift',
        shuffle_`name^`plural^  => 'shuffle',
        sorted_`name^`plural^   => 'sort',
        splice_`name^`plural^   => 'splice',
        uniq_`name^`plural^     => 'uniq',
        unshift_`name^`plural^  => 'unshift',
    },
);


XPT csvn "New CSV wrtier"
my $`csv^ = Text::CSV_XS->new ({ binary => 1, eol => $/, quote_null => 0, auto_diag => 1, }) or
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
    my (`args^) = @_;
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
use strict;
use warnings;
use utf8;

package `package^;

#ABSTRACT:  `abstract^

use Modern::Perl qw/ 2012 /;

use Moose;
use namespace::autoclean;

with 'MooseX::Log::Log4perl';

#  Aliases
use  MooseX::Aliases;
#  use aliased '`package^',

#  Extra modules
use Data::Printer;


=encoding utf8

=for Pod::Coverage

=head1 SYNOPSIS

    use MooseX::Aliases;
    use aliased '`package^';

=head1 DESCRIPTION

`description^

=cut


#  For speed
__PACKAGE__->meta->make_immutable;
1;
..XPT



