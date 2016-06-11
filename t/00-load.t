#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'CardGame::Match' ) || print "Bail out!\n";
}

diag( "Testing CardGame::Match $CardGame::Match::VERSION, Perl $], $^X" );
