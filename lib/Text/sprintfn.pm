package Text::sprintfn;

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT    = qw(sprintfn printfn);

sub sprintfn {
    my ($format, $hash_arg, @args) = @_;
    # XXX
}

sub printfn {
    print sprintfn @_;
}

1;
# ABSTRACT: Drop-in replacement for sprintf(), with named parameter support

=head1 SYNOPSIS

 use Text::sprintfn; # by default exports sprintfn() and printfn()

 printfn("<%2d> <%(foo)-(bar).2f> <%0$04d>", {foo=>1, bar=>5}, 3, 42);
 # < 3> <1.00 > <0003>

 print sprintf "<%-4d>", 123; # no hash provided, acts like normal sprintf()
 # <123 >

=head1 DESCRIPTION

This module provides sprintfn() and printfn(), which are like sprintf() and
printf(), with the exception that they support named parameters from a hash.

There exist other CPAN modules for string formatting with named parameter
support, but this one focuses on interface simplicity and sprintf compatibility
since most people are already familiar with it and it has several features.


=head1 FUNCTIONS

=head2 sprintfn FORMAT, HASH_ARG, OTHER_ARG, ...

If first argument after format is not a hash, sprintfn() will behave exactly
like sprintf().

If HASH_ARG is given, sprintfn() will look for named parameters in argument and
supply the values from the hash. Named parameters are surrounded with
parentheses, i.e. "(NAME)". They can occur in format parameter index:

 %2$d        # sprintf version, take argument at index 2
 %(two)d     # $ is optional
 %(two)$d    # same

or in minimum width:

 %-10d       # sprintf version, use minimum width of 10
 %-(width)d  # like sprintf, but use minimum width from hash key 'width'
 %(var)-(width)d  # format hash key 'var' w/ minimum width from hash key 'width'

or in precision:

 %6.2f       # sprintf version, use precision of 2 decimals
 %6.(prec)f  # like sprintf, but use precision from hash key 'prec'
 %(width).(prec)f
 %(var)(width).(prec)f

The existence of formats using hash keys will not affect indexes of the rest of
the argument, example:

 sprintfn "<%(v1)s> <%2$d> <%d>", {v1=>10}, 0, 1, 2; # "<10> <2> <0>"

Like sprintf(), if format is unknown/erroneous, it will be printed as-is.

=head2 printfn

Equivalent to "print sprintf(@_)".


=head1 TIPS AND TRICKS

=head2 Common mistake 1

Writing

 %(var)

instead of

 %(var)s

=head2 Common mistake 2 (a bit more newbish)

Writing

 sprintf $format, %hash, ...;

instead of

 sprintf $format, \%hash, ...;

=head2 Alternative hashes

You have several hashes (%h1, %h2, %h3) which should be consulted for values.
You can either merge the hash first:

 %h = (%h1, %h2, %h3); # or one of several available module for hash merging
 printfn $format, \%h, ...;

or create a tied hash which can consult hashes for you:

 tie %h, 'Your::Module', \%h1, \%h2, \%h3;
 printfn $format, \%h, ...;


=head1 SEE ALSO

sprintf() section on L<perlfunc>

L<String::Flogger>

L<String::Formatter>

L<Text::Sprintf::Named>

=cut

