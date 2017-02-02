package Fulla::Commands::Artikel;

use v5.20;
use strict;
use warnings;

use Fulla::Werchzueg;

sub reply {
    my $class   = shift;
    my $artikel = shift;
    my $log     = Fulla::Werchzueg->get_logger();
    my $dbh     = Fulla::Werchzueg->get_database();

    my $answer = '';

    my $sql = "SELECT * FROM artikel WHERE bezeichnung LIKE '%$artikel%'";

    $log->debug("QUERY: $sql");

    my @arr = @{$dbh->selectall_arrayref($sql)};

    foreach my $a (@arr) {
        $answer .= join("\t", @{$a});
        $answer .= "\n";
    }

    return $answer;

}

1;

    
