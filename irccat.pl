#!/usr/bin/perl

use strict;
use warnings;

use POE qw/
    Component::IRC
    Component::IRC::Plugin::FollowTail
/;

my $channel = '#irccat';

my %tail_files = (

    system         => "/var/log/messages.log",
);

my $irc = POE::Component::IRC->spawn(

    Nick                    => 'irccat',
    Username                => 'irccat',
    Ircname                 => 'irccat in POE::Component::IRC',
    UseSSL                  => 1,
    Server                  => 'irc.example.org',
    Port                    => 6697,
    Flood                   => 1,
    Password                => '',
#   SSLCert                 => "/usr/local/irccat/irccat.crt",
#   SSLKey                  => "/usr/local/irccat/irccat.key"
);

POE::Session->create(
    package_states => [
        main => [ qw/
                _start
                irc_001
                irc_tail_input
                irc_tail_reset
        / ]
    ],
    heap => { irc => $irc }
);

sub _start
{
    my ($heap) = $_[ HEAP ];

    while (my ($alias, $filename) = each %tail_files) {

        $heap->{irc}->plugin_add("follow_tail_$alias" => POE::Component::IRC::Plugin::FollowTail->new(filename => $filename))
    }
    $heap->{irc}->yield(register => 'all');
    $heap->{irc}->yield(connect => { });
}

sub irc_001
{
    $_[HEAP]->{irc}->yield(join => $channel)
}

sub irc_tail_input
{
    my ($heap, $filename, $input)
        = @_[ HEAP, ARG0, ARG1 ];

    $input =~ s/[A-Z]+ \d{2} \d{2}:\d{2}:\d{2} //i;

    return if ($input =~ /^\[dovecot\]/);

    $heap->{irc}->yield(privmsg => $channel => $input)
}

sub irc_tail_reset
{
    my ($heap, $filename)
        = @_[ HEAP, ARG0 ];

    $heap->{irc}->yield(privmsg => $channel => "--- $filename reset ---")
}

POE::Kernel->run;
exit;
