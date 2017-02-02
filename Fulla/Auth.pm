package Fulla::Auth;

use v5.20;
use strict;
use warnings;

use DBI; # with DBD::mysql
use Digest;
use Digest::Bcrypt;
use String::Random;

sub new {
    my $class = shift;

    my $log   = Fulla::Werchzueg->get_logger();
    my $dbh   = Fulla::Werchzueg->get_database();

    my $self = { log        => $log,
                 dbh        => $dbh,
                 SESSION    => {},
                 AUTH_MSG   => '',
               };
    bless $self, $class;

    return $self;
}

sub check {
    my $self    = shift;
    my $command = shift;

    if ( $command =~ /^\d*\slogin\s(\S+)\s(\S+)/) { 
        my $user = $1; 
        my $pass = $2; 

        my $bcrypt_client = Digest->new ( 'Bcrypt' )
                                  ->cost( 1 )
                                  ->salt('0000000000000000')
                                  ->add ($pass)
                                  ->hexdigest;

        my $sql = "SELECT pw_hash FROM user WHERE name = '$user'";
        $self->{log}->debug("QUERY: $sql");
        my $bcrypt_db     = $self->{dbh}->selectrow_array($sql);

        $self->{log}->debug("Hash DB: $bcrypt_db / Hash Client: $bcrypt_client");

        if ($bcrypt_client eq $bcrypt_db) {
            my $session_id = String::Random->new->randregex('\d{20}');
            $self->{SESSION}->{$session_id} = 1;

            return ( $session_id, 'login ok' );;
        }   
        else {
            return ( 0, 'login failed' );;
        }   
    }
    elsif ( $command =~ /^(\d{20})\s.*$/ ) {
        my $session_id = $1;

        if ( exists $self->{SESSION}->{$session_id} ) {
            return ( $session_id, 'session valid' );
        }
        else {
            $self->{log}->info("session not valid: $session_id");
            return ( 0, 'session not valid' );
        }
    }
    else {
        return ( 0, 'no session found' );
    }
}

1;

