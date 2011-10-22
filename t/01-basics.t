#!perl -T

use 5.010;
use strict;
use warnings;

#use Data::Dump::OneLine qw(dump1);
use Test::More 0.96;
use Text::sprintfn;

test_sprintfn(
    name => "normal printf args",
    args => ["%d, %04x, %1$-6.2f", {}, 10, 17],
    res  => "10, 0011,  17.00");


DONE_TESTING:
done_testing();

sub test_sprintf {
    my (%args) = @_;

    my $test_name = $args{name} // "fmt $args{args}[0]";
    subtest $test_name => sub {
        my $res = sprintfn(%args{args});
        is($res, $args{res}, "result");
    };
}

