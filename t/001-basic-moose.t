#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 9;

BEGIN { delete $ENV{ANY_MOOSE} }

do {
    package Moused::Any::Moose;
    use Any::Moose;

    ::ok(__PACKAGE__->can('meta'), 'Mo*se was installed');
    ::like(__PACKAGE__->meta, qr/^Mouse/, 'Mouse was installed');

    ::is(any_moose, 'Mouse');
    ::is(any_moose('::Util::TypeConstraints'), 'Mouse::Util::TypeConstraints');

    ::is(any_moose, 'Mouse', 'still Mouse even if Moose is loaded');

    no Any::Moose;
};

ok(!Moused::Any::Moose->can('has'), "has was unimported");

SKIP: {
    my $loaded_moose;
    BEGIN { $loaded_moose = eval 'require Moose' }
    skip "Moose required for these tests to be useful" => 3 unless $loaded_moose;

    do {
        package After::Moose;
        use Any::Moose;

        ::is(any_moose, 'Mouse');
        ::is(any_moose('::Util::TypeConstraints'), 'Mouse::Util::TypeConstraints');

        no Any::Moose;
    };

    ok(!After::Moose->can('has'), "has was unimported");
}
