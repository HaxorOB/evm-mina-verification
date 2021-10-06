//---------------------------------------------------------------------------//
// Copyright (c) 2018-2020 Mikhail Komarov <nemo@nil.foundation>
//
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//---------------------------------------------------------------------------//

#ifndef CRYPTO3_PUBKEY_COMPLEXITY_HPP
#define CRYPTO3_PUBKEY_COMPLEXITY_HPP

#include <algorithm>
#include <numeric>

namespace nil {
    namespace crypto3 {
        namespace pubkey {
            namespace complexity {
                namespace detail {
                    std::size_t nfs_complexity(std::size_t bits, double k) {
                        // approximates natural logarithm of integer of given bitsize
                        const double log2_e = std::log2(std::exp(1));
                        const double log_p = bits / log2_e;

                        const double log_log_p = std::log(log_p);

                        // RFC 3766: k * e^((1.92 + o(1)) * cubrt(ln(n) * (ln(ln(n)))^2))
                        const double est = 1.92 * std::pow(log_p * log_log_p * log_log_p, 1.0 / 3.0);

                        // return log2 of the workfactor
                        return static_cast<std::size_t>(std::log2(k) + log2_e * est);
                    }
                }    // namespace detail

                /**
                 * Return the appropriate exponent size to use for a particular prime
                 * group. This is twice the size of the estimated cost of breaking the
                 * key using an index calculus attack; the assumption is that if an
                 * arbitrary discrete log on a group of size bits would take about 2^n
                 * effort, and thus using an exponent of size 2^(2*n) implies that all
                 * available attacks are about as easy (as e.g Pollard's kangaroo
                 * algorithm can compute the DL in sqrt(x) operations) while minimizing
                 * the exponent size for performance reasons.
                 */

                std::size_t dl_exponent_size(std::size_t prime_group_size) {
                    /*
                    This uses a slightly tweaked version of the standard work factor
                    function above. It assumes k is 1 (thus overestimating the strength
                    of the prime group by 5-6 bits), and always returns at least 128 bits
                    (this only matters for very small primes).
                    */
                    const std::size_t MIN_WORKFACTOR = 64;

                    return 2 * std::max<std::size_t>(MIN_WORKFACTOR, detail::nfs_complexity(prime_group_size, 1));
                }

                /**
                 * Estimate work factor for integer factorization
                 * @param n_bits size of modulus in bits
                 * @return estimated security level for this modulus
                 */
                std::size_t integer_factorization(std::size_t n_bits) {
                    // RFC 3766 estimates k at .02 and o(1) to be effectively zero for sizes of interest

                    return detail::nfs_complexity(n_bits, .02);
                }

                /**
                 * Estimate work factor for discrete logarithm
                 * @param prime_group_size size of the group in bits
                 * @return estimated security level for this group
                 */
                std::size_t discrete_logarithm(std::size_t prime_group_size) {
                    // Lacking better estimates...
                    return integer_factorization(prime_group_size);
                }

                /**
                 * Estimate work factor for EC discrete logarithm
                 * @param prime_group_size size of the group in bits
                 * @return estimated security level for this group
                 */
                std::size_t ec_discrete_logarithm(std::size_t prime_group_size) {
                    return prime_group_size / 2;
                }
            }    // namespace complexity
        }        // namespace pubkey
    }            // namespace crypto3
}    // namespace nil

#endif
