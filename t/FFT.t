package Math::GSL::FFT::Test;
use base q{Test::Class};
use Test::Most;
use Math::GSL::Test  qw/:all/;
use Math::GSL::FFT   qw/:all/;
use Math::GSL        qw/:all/;
use Math::GSL::Errno qw/:all/;
use Data::Dumper;
use strict;
use warnings;

BEGIN { gsl_set_error_handler_off() }

sub make_fixture : Test(setup) {
}

sub teardown : Test(teardown) {
    unlink 'fft' if -f 'fft';
}

sub FFT_REAL_TRANSFORM : Tests
{
    my $input  = [ 0 .. 6 ];
    my $N      = @$input;

    my $workspace1          = gsl_fft_real_workspace_alloc($N);
    my $wavetable1          = gsl_fft_real_wavetable_alloc($N);
    my ($status, $output )  = gsl_fft_real_transform ($input, 1, $N, $wavetable1, $workspace1);
    ok_status($status);

    my $workspace2          = gsl_fft_real_workspace_alloc($N);
    my $wavetable2          = gsl_fft_halfcomplex_wavetable_alloc($N);
    my ($status2, $output2) = gsl_fft_halfcomplex_backward($output, 1, $N, $wavetable2, $workspace2);
    ok_status($status2);

    # F = F^(-1)/$N on real inputs
    ok_similar( $input, [ map { $_ / $N } @$output2 ] );

    my $wavetable3          = gsl_fft_halfcomplex_wavetable_alloc($N);
    my $workspace3          = gsl_fft_real_workspace_alloc($N);
    my ($status3, $output3) = gsl_fft_halfcomplex_inverse($output, 1, $N, $wavetable3, $workspace3);
    ok_status($status3);

    # F = F^(-1) on real inputs
    ok_similar( $input, $output3 );
}

sub FFT_REAL_RADIX2_TRANSFORM : Tests
{
    my $N      = 8;
    my $input  = [ 0 .. 7 ];
    my ($status, $output ) = gsl_fft_real_radix2_transform ($input, 1, $N);
    ok_status($status);

    my ($status2, $output2) = gsl_fft_halfcomplex_radix2_backward($output, 1, $N);
    ok_status($status2);

    # F = F^(-1) / N on real inputs
    ok_similar( $input, [ map { $_ / $N } @$output2 ] );

    my ($status3, $output3) = gsl_fft_halfcomplex_radix2_inverse($output, 1, $N);
    ok_status($status3);

    # F = F^(-1) on real inputs
    ok_similar( $input, $output3 );

    # TODO
    #   Failed test 'FFT_REAL_RADIX2_TRANSFORM died (TypeError in method
    #   'gsl_fft_halfcomplex_radix2_unpack', argument 2 of type 'double []' at
    #   t/FFT.t line 36.)'
    #my $blarg = map { $_ + 0.1 } ( 0 .. 7 );
    #my ($status3,$complex_array) = gsl_fft_halfcomplex_radix2_unpack($output, $blarg, 1, $N);
    #ok_status($status3);
}

sub FFT_COMPLEX_RADIX2_FORWARD : Tests
{
    my $data = [ 0 .. 7 ];
    my $N = @$data;
    my ($status1, $output1) = gsl_fft_complex_radix2_forward ($data, 1, $N / 2);
    ok_status($status1);
    ok( defined $output1, 'got data back');

    # this seems to non-deterministically fail OR cause a core dump
    #my ($status2, $output2) = gsl_fft_complex_radix2_inverse($output1, 1, $N / 2);
    #ok_status($status2);
    #warn Dumper [ $data, $output1,  $output2 ];
    #ok_similar($data, $output2);
}

sub FFT_VARS : Tests {
    cmp_ok( $gsl_fft_forward, '==', -1, 'gsl_fft_forward' );
    cmp_ok( $gsl_fft_backward, '==', +1, 'gsl_fft_backward' );
}

sub WAVETABLE_ALLOC_FREE: Tests {
    my $wavetable = gsl_fft_complex_wavetable_alloc(42);
    isa_ok($wavetable, 'Math::GSL::FFT' );
    gsl_fft_complex_wavetable_free($wavetable);
    ok(!$@, 'gsl_fft_complex_wavetable_free');

    $wavetable = gsl_fft_halfcomplex_wavetable_alloc(42);
    isa_ok($wavetable, 'Math::GSL::FFT' );
    gsl_fft_halfcomplex_wavetable_free($wavetable);
    ok(!$@, 'gsl_fft_halfcomplex_wavetable_free');

    $wavetable = gsl_fft_real_wavetable_alloc(42);
    isa_ok($wavetable, 'Math::GSL::FFT' );
    gsl_fft_real_wavetable_free($wavetable);
    ok(!$@, 'gsl_fft_real_wavetable_free');

}

sub WORKSPACE_ALLOC_FREE: Tests {
    my $workspace = gsl_fft_complex_workspace_alloc(42);
    isa_ok($workspace, 'Math::GSL::FFT' );
    gsl_fft_complex_workspace_free($workspace);
    ok(!$@, 'gsl_fft_complex_workspace_free');

    # there are no gsl_fft_halfcomplex_workspace_* functions

    $workspace = gsl_fft_real_workspace_alloc(42);
    isa_ok($workspace, 'Math::GSL::FFT' );
    gsl_fft_real_workspace_free($workspace);
    ok(!$@, 'gsl_fft_real_workspace_free');
}
Test::Class->runtests;
