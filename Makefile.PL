use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'CardGame::Match',
    AUTHOR           => q{Mirela Iclodean <imirela@cpan.org>},
    VERSION_FROM     => 'lib/CardGame/Match.pm',
    ABSTRACT_FROM    => 'lib/CardGame/Match.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'      => 0,
        'Test::Exception' => 0
    },
    PREREQ_PM => {
        'Moose'                 => undef,
        'Carp'                  => undef,
        'Class::Load'           => undef,
        'Data::Dump'            => undef,
        'MooseX::Types::Moose'  => undef,
        'true'                  => undef,
        'List::Util'            => undef,
        'namespace::autoclean'  => undef,
        'Pod::Usage'            => undef,
        'Getopt::Long'          => undef,
        'mro'                   => undef,
        'FindBin::libs'         => undef,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'CardGame-Match-*' },
);
