#!/usr/bin/env perl
use Modern::Perl;

use autodie;
use File::Slurp;
use File::Spec;

use Readonly;
Readonly::Scalar  my $BASE       => 'vimconfigs';
Readonly::Scalar  my $CONF_FILE  => '_vimrc';

my @out;
for  my $file  (sort grep {/\.(?:txt|vim)$/i} read_dir($BASE)){
    my $filename = File::Spec->catfile($BASE, $file);
    open  my $fh, '<', $filename;
    while (<$fh>){
        chomp;
        s/\s+$//;
        push @out, "$_\n"  unless  /^\s*(?:"|$)/;
    }
}

write_file ($CONF_FILE, {atomic => 1, binmode => ':raw'}, \@out);
