///////////////////////////////////////////////////////////////
//  Copyright Christopher Kormanyos 2002 - 2011.
//  Copyright 2011 John Maddock. Distributed under the Boost
//  Software License, Version 1.0. (See accompanying file
//  LICENSE_1_0.txt or copy at https://www.boost.org/LICENSE_1_0.txt
//
// This work is based on an earlier work:
// "Algorithm 910: A Portable C++ Multiple-Precision System for Special-Function Calculations",
// in ACM TOMS, {VOL 37, ISSUE 4, (February 2011)} (C) ACM, 2011. http://doi.acm.org/10.1145/1916461.1916469

#ifdef _MSC_VER
#define _SCL_SECURE_NO_WARNINGS
#endif

#include <boost/detail/lightweight_test.hpp>
#include "test.hpp"

#include <nil/crypto3/multiprecision/mpfr.hpp>
#include <nil/crypto3/multiprecision/mpc.hpp>

template<class T>
T make_rvalue_copy(const T a) {
    return a;
}

int main() {
    using namespace nil::crypto3::multiprecision;
    //
    // Test change of default precision:
    //
    mpfr_float::default_precision(100);
    mpfr_float a("0.1");
    BOOST_CHECK_EQUAL(a.precision(), 100);
    mpfr_float::default_precision(20);
    {
        // test assignment from lvalue:
        mpfr_float b(2);
        BOOST_CHECK_EQUAL(b.precision(), 20);
        b = a;
        BOOST_CHECK_EQUAL(b.precision(), a.precision());
    }
#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES
    {
        // test assignment from rvalue:
        mpfr_float b(2);
        BOOST_CHECK_EQUAL(b.precision(), 20);
        b = make_rvalue_copy(a);
        BOOST_CHECK_EQUAL(b.precision(), a.precision());
    }
#endif
    mpfr_float::default_precision(20);
    {
        // test construct from lvalue:
        mpfr_float b(a);
        BOOST_CHECK_EQUAL(b.precision(), 100);
    }
#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES
    {
        // test construct from rvalue:
        mpfr_float b(make_rvalue_copy(a));
        BOOST_CHECK_EQUAL(b.precision(), 100);
    }
#endif
    mpc_complex::default_precision(100);
    mpc_complex ca("0.1");
    BOOST_CHECK_EQUAL(ca.precision(), 100);
    mpc_complex::default_precision(20);
    {
        // test assignment from lvalue:
        mpc_complex b(2);
        BOOST_CHECK_EQUAL(b.precision(), 20);
        b = ca;
        BOOST_CHECK_EQUAL(b.precision(), ca.precision());
    }
#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES
    {
        // test assignment from rvalue:
        mpc_complex b(2);
        BOOST_CHECK_EQUAL(b.precision(), 20);
        b = make_rvalue_copy(ca);
        BOOST_CHECK_EQUAL(b.precision(), ca.precision());
    }
#endif
    {
        // test construct from lvalue:
        mpc_complex b(ca);
        BOOST_CHECK_EQUAL(b.precision(), ca.precision());
    }
#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES
    {
        // test construct from rvalue:
        mpc_complex b(make_rvalue_copy(ca));
        BOOST_CHECK_EQUAL(b.precision(), ca.precision());
    }
#endif
    // real and imaginary:
    BOOST_CHECK_EQUAL(ca.real().precision(), 100);
    BOOST_CHECK_EQUAL(ca.imag().precision(), 100);
    BOOST_CHECK_EQUAL(real(ca).precision(), 100);
    BOOST_CHECK_EQUAL(imag(ca).precision(), 100);

    //
    // Construction at specific precision:
    //
    {
        mpfr_float f150(mpfr_float(), 150u);
        BOOST_CHECK_EQUAL(f150.precision(), 150);
        mpc_complex f150c(mpc_complex(), 150u);
        BOOST_CHECK_EQUAL(f150c.precision(), 150);
        mpc_complex f150cc(mpfr_float(), mpfr_float(), 150u);
        BOOST_CHECK_EQUAL(f150cc.precision(), 150);
    }
    {
        mpfr_float f150(2, 150);
        BOOST_CHECK_EQUAL(f150.precision(), 150);
    }
    {
        mpfr_float f150("1.2", 150);
        BOOST_CHECK_EQUAL(f150.precision(), 150);
    }
    //
    // Copying precision:
    //
    {
        mpc_complex c(ca.backend().data());
        BOOST_CHECK_EQUAL(c.precision(), 100);
        mpc_complex_100 c100(2);
        mpc_complex d(c100);
        BOOST_CHECK_EQUAL(d.precision(), 100);
        mpfr_float_100 f100(2);
        mpc_complex e(f100);
        BOOST_CHECK_EQUAL(d.precision(), 100);
    }
    //
    // Check that the overloads for precision don't mess up 2-arg
    // construction:
    //
    {
        mpc_complex c(2, 3u);
        BOOST_CHECK_EQUAL(c.real(), 2);
        BOOST_CHECK_EQUAL(c.imag(), 3);
    }
    //
    // 3-arg complex number construction with 3rd arg a precision:
    //
    {
        mpc_complex c(2, 3, 100);
        BOOST_CHECK_EQUAL(c.precision(), 100);
        mpfr_float_50 x(2), y(3);
        mpc_complex z(x, y, 100);
        BOOST_CHECK_EQUAL(c.precision(), 100);
    }
    //
    // From https://github.com/boostorg/multiprecision/issues/65
    //
    {
        mpfr_float a(2);
        a.precision(100);
        BOOST_CHECK_EQUAL(a, 2);
        BOOST_CHECK_EQUAL(a.precision(), 100);
    }
    {
        mpc_complex a(2, 3);
        a.precision(100);
        BOOST_CHECK_EQUAL(a.real(), 2);
        BOOST_CHECK_EQUAL(a.imag(), 3);
        BOOST_CHECK_EQUAL(a.precision(), 100);
    }
    {
        mpc_complex::default_precision(1000);
        mpfr_float::default_precision(1000);
        mpc_complex a(
            "1."
            "3247198273940861203984190827349801267340896123098710928309812367489012734980712409861230948612469812634812"
            "6348901623894714712980741902874890127340912734908712461257612907654120397570419569041857091465791046509125"
            "6016501650916509165097164509164509761409561097561097650791650971465097165097162059761209561029756019265019"
            "7265091265091726509716250971624509713097561049756102746509178250187409812740981274091823757014651723409238"
            "47120836540491320467127043127893281461230951097260126309812374091265091824981231236409851274",
            "-0."
            "8074389126739461098265907145234615610276431240157197264239412039560829147102934781264512598612312390412347"
            "1209381289471230512983491286102875870192091283712396550981723409812740981263471230498715096104897123094710"
            "9238790659817409287409812718013912092384701295609418701293874098128834378941838838412837004838328832181284"
            "3893818428914823916407932965786120938189203748346893748923741923650982372370561289348971241230653127481236"
            "4980127304981648712483248732");
        mpc_complex::default_precision(40);
        mpfr_float::default_precision(40);
        BOOST_CHECK_EQUAL(a, a);
    }

    //
    // string_view with explicit precision:
    //
#ifndef BOOST_NO_CXX17_HDR_STRING_VIEW
    {
        std::string s("222");
        std::string_view v(s.c_str(), 1);
        mpfr_float f(v, 100);
        BOOST_CHECK_EQUAL(f, 2);
        BOOST_CHECK_EQUAL(f.precision(), 100);
    }
    {
        std::string x("222"), y("333");
        std::string_view vx(x.c_str(), 1), vy(y.c_str(), 1);
        mpc_complex c(vx, vy, 100);
        BOOST_CHECK_EQUAL(c.real(), 2);
        BOOST_CHECK_EQUAL(c.imag(), 3);
        BOOST_CHECK_EQUAL(c.precision(), 100);
    }
#endif
    {
        mpc_complex::default_precision(100);
        mpfr_float::default_precision(100);
        mpfr_float a(1);
        mpfr_float b(2);

        mpc_complex::default_precision(50);
        mpfr_float::default_precision(50);

        mpc_complex z(a, b);

        BOOST_CHECK_EQUAL(z.precision(), 100);
    }
    // Swap:
    {
        mpfr_float x(2, 100);    // 100 digits precision.
        mpfr_float y(3, 50);     // 50 digits precision.
        swap(x, y);
        BOOST_CHECK_EQUAL(x, 3);
        BOOST_CHECK_EQUAL(y, 2);
        BOOST_CHECK_EQUAL(x.precision(), 50);
        BOOST_CHECK_EQUAL(y.precision(), 100);
        x.swap(y);
        BOOST_CHECK_EQUAL(x, 2);
        BOOST_CHECK_EQUAL(y, 3);
        BOOST_CHECK_EQUAL(x.precision(), 100);
        BOOST_CHECK_EQUAL(y.precision(), 50);
#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES
        x = std::move(mpfr_float(y));
        BOOST_CHECK_EQUAL(x, y);
        BOOST_CHECK_EQUAL(x.precision(), y.precision());
#endif
    }
    {
        mpc_complex x(2, 3, 100);    // 100 digits precision.
        mpc_complex y(3, 4, 50);     // 50 digits precision.
        swap(x, y);
        BOOST_CHECK_EQUAL(x.real(), 3);
        BOOST_CHECK_EQUAL(x.imag(), 4);
        BOOST_CHECK_EQUAL(y.real(), 2);
        BOOST_CHECK_EQUAL(y.imag(), 3);
        BOOST_CHECK_EQUAL(x.precision(), 50);
        BOOST_CHECK_EQUAL(y.precision(), 100);
        x.swap(y);
        BOOST_CHECK_EQUAL(x.real(), 2);
        BOOST_CHECK_EQUAL(x.imag(), 3);
        BOOST_CHECK_EQUAL(y.real(), 3);
        BOOST_CHECK_EQUAL(y.imag(), 4);
        BOOST_CHECK_EQUAL(x.precision(), 100);
        BOOST_CHECK_EQUAL(y.precision(), 50);
#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES
        x = std::move(mpc_complex(y));
        BOOST_CHECK_EQUAL(x, y);
        BOOST_CHECK_EQUAL(x.precision(), y.precision());
#endif
    }
    {
        mpfr_float c(4), d(8), e(9), f;
        f = (c + d) * d / e;
        mpfr_float g((c + d) * d / e);
    }
    {
        mpfr_float::default_precision(100);
        mpfr_float f1;
        f1 = 3;
        BOOST_CHECK_EQUAL(f1.precision(), 100);
        f1 = 3.5;
        BOOST_CHECK_EQUAL(f1.precision(), 100);
        mpfr_float f2(3.5);
        BOOST_CHECK_EQUAL(f2.precision(), 100);
        mpfr_float f3("5.1");
        BOOST_CHECK_EQUAL(f3.precision(), 100);

        mpfr_float::default_precision(50);
        mpfr_float f4(f3, 50);
        BOOST_CHECK_EQUAL(f4.precision(), 50);
        f4.assign(f1, f4.precision());
        BOOST_CHECK_EQUAL(f4.precision(), 50);
    }
    {
        //
        // Overloads of Math lib functions, discovered while fixing
        // https://github.com/boostorg/multiprecision/issues/91
        //
        mpfr_float::default_precision(100);
        mpfr_float f1;
        f1 = 3;
        BOOST_CHECK_EQUAL(f1.precision(), 100);
        mpfr_float::default_precision(20);
        BOOST_CHECK_EQUAL(asinh(f1).precision(), 100);
        BOOST_CHECK_EQUAL(acosh(f1).precision(), 100);
        BOOST_CHECK_EQUAL(atanh(f1).precision(), 100);
        BOOST_CHECK_EQUAL(cbrt(f1).precision(), 100);
        BOOST_CHECK_EQUAL(erf(f1).precision(), 100);
        BOOST_CHECK_EQUAL(erfc(f1).precision(), 100);
        BOOST_CHECK_EQUAL(expm1(f1).precision(), 100);
        BOOST_CHECK_EQUAL(lgamma(f1).precision(), 100);
        BOOST_CHECK_EQUAL(tgamma(f1).precision(), 100);
        BOOST_CHECK_EQUAL(log1p(f1).precision(), 100);
    }

    return boost::report_errors();
}
