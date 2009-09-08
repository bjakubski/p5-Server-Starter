#! /usr/bin/perl

use strict;
use warnings;

use lib qw(blib/lib lib);

use IO::Socket::INET;
use Server::Starter qw(server_ports);

$SIG{TERM} = sub {
    exit 0;
};

my $listener = IO::Socket::INET->new(
    Proto => 'tcp',
);
$listener->fdopen((values %{server_ports()})[0], 'w')
    or die "failed to bind listening socket:$!";

# intentionally not send USR2, sent by the test script
# kill 'USR2', getppid();

while (1) {
    if (my $conn = $listener->accept) {
        my $buf;
        while ($conn->sysread($buf, 1048576) > 0) {
            $conn->syswrite("$$:$buf");
        }
    }
}
