package Fulla::Werchzueg;

use v5.20;
use strict;
use warnings;

my $database = undef;
my $logger   = undef;

sub set_database {
    my $class        = shift;
    my $new_database = shift;

    $database = $new_database;
}

sub get_database {
    return $database;
}

sub set_logger {
    my $class      = shift;
    my $new_logger = shift;

    $logger = $new_logger;
}

sub get_logger {
    return $logger;
}

1;

# Reminder Singleton:
# http://perltricks.com/article/52/2013/12/11/Implementing-the-singleton-pattern-in-Perl/
