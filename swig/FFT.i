%module "Math::GSL::FFT"
%include "typemaps.i"
%include "gsl_typemaps.i"
%include "renames.i"

// These must come before our %include's
%typemap(argout) (double data[], const size_t stride, const size_t n) {
    int i=0;
    AV* tempav = newAV();

    while( i < $3 ) {
        av_push(tempav, newSVnv((double) $1[i]));
        i++;
    }

    $result = sv_2mortal( newRV_noinc( (SV*) tempav) );
    argvi++;
}

%typemap(argout) (const double halfcomplex_coefficient[], double * complex_coefficient, size_t stride, size_t n) {
    int i=0;
    AV* tempav = newAV();

    while( i < $4 ) {
        av_push(tempav, newSVnv((double) $2[i]));
        i++;
    }

    $result = sv_2mortal( newRV_noinc( (SV*) tempav) );
    argvi++;
}

%typemap(argout) (gsl_complex_packed_array data, const size_t stride, const size_t n) {
    int i=0;
    AV* tempav = newAV();

    while( i < $3 ) {
        av_push(tempav, newSVnv((double) $1[i]));
        i++;
    }

    $result = sv_2mortal( newRV_noinc( (SV*) tempav) );
    argvi++;
}


%include "gsl/gsl_inline.h"
%include "gsl/gsl_math.h"
%include "gsl/gsl_sys.h"
%include "gsl/gsl_pow_int.h"
%include "gsl/gsl_nan.h"
%include "gsl/gsl_machine.h"
%include "gsl/gsl_complex.h"
%include "gsl/gsl_fft.h"
%include "gsl/gsl_fft_complex.h"
%include "gsl/gsl_fft_halfcomplex.h"
%include "gsl/gsl_fft_real.h"
%include "../pod/FFT.pod"


%{
    #include "gsl/gsl_inline.h"
    #include "gsl/gsl_complex.h"
    #include "gsl/gsl_sys.h"
    #include "gsl/gsl_pow_int.h"
    #include "gsl/gsl_nan.h"
    #include "gsl/gsl_machine.h"
    #include "gsl/gsl_math.h"
    #include "gsl/gsl_fft.h"
    #include "gsl/gsl_fft_complex.h"
    #include "gsl/gsl_fft_halfcomplex.h"
    #include "gsl/gsl_fft_real.h"
%}
