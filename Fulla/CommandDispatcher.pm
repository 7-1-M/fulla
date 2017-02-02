package Fulla::CommandDispatcher;

use v5.20;
use strict;
use warnings;

use DBI; # with DBD::mysql

use Fulla::Auth;
use Fulla::Commands::Login;
use Fulla::Commands::Ping;
use Fulla::Commands::Artikel;
use Fulla::Commands::Ls;

sub new {
    my $class = shift;

    my $log   = Fulla::Werchzueg->get_logger();
    my $dbh   = Fulla::Werchzueg->get_database();
    my $auth  = Fulla::Auth->new();

    my $self = { log  => $log,
                 dbh  => $dbh,
                 auth => $auth,
               };
    bless $self, $class;

    return $self;
}

sub do {
    my $self    = shift;
    my $command = shift;

    my $answer     = '';

    my ($session, $auth_msg) = $self->{auth}->check($command);

    $self->{log}->debug( "session after auth: $session");

    if ( $session == 0 ) {
        $self->{log}->info("auth problem: $auth_msg");
        $answer = "0 $auth_msg";
        # EXIT
        return $answer;
    }

    $self->{log}->debug( "command before parse: $command");

    if ($command =~ /^\d+\s(.*)/) {

        $command = $1;

        $self->{log}->debug( "command in parse: $command" );

        given ($command) {

            # LOGIN
            when (/^login/) {
                $answer = Fulla::Commands::Login->reply();
            }

            # PING
            when (/^ping/)  {
                $answer = Fulla::Commands::Ping->reply();
            }
    
            # ARTIKEL
            when (/^artikel\s(.*)/) { 
                my $artikel = $1;
                $answer = Fulla::Commands::Artikel
                            ->reply( $artikel );
            }

            # LS
            when (/^ls\s?(.*)/)  {
                my $option = $1;
                $answer = Fulla::Commands::Ls->reply($option);
            }
    
            # DEFAULT
            default {
                $answer = "command unknown: $command"
            }
        }
    }
    else {
        $answer = "command unknown: $command";
    }

    return "$session $answer";
}

1;

    
