#!/usr/bin/env perl

use FindBin::libs;
use mro;

=head1 DESCRIPTION

Test::Class runner for t/model/

You can run these all together by running

  prove -vl t/model/run_test_class.t

or individualy, by running

  prove -vl t/model/class/Test/Card.pm

=cut

use Test::Class::Load "./t/model/class";

my @test_classes = @{mro::get_isarev('Test::Class')};

Test::Class->runtests(sort @test_classes);