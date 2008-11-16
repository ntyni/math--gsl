package Math::GSL::Siman::Test;
use base q{Test::Class};
use Test::More;
use Math::GSL           qw/:all/;
use Math::GSL::Siman qw/:all/;
use Math::GSL::Test     qw/:all/;
use Math::GSL::Errno    qw/:all/;
use Data::Dumper;
use strict;

BEGIN { gsl_set_error_handler_off(); }

sub make_fixture : Test(setup) {
}

sub teardown : Test(teardown) {
}

sub GSL_SIMAN : Tests {
    ok(1);
}

Test::Class->runtests;
