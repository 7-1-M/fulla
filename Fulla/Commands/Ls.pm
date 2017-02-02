package Fulla::Commands::Ls;

use v5.20;
use strict;
use warnings;

sub reply {
    my $class  = shift;
    my $option = shift;

    return `ls $option`;

}

1;

    
