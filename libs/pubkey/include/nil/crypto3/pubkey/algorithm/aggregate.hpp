//---------------------------------------------------------------------------//
// Copyright (c) 2020 Mikhail Komarov <nemo@nil.foundation>
// Copyright (c) 2020 Ilias Khairullin <ilias@nil.foundation>
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

#ifndef CRYPTO3_PUBKEY_AGGREGATE_HPP
#define CRYPTO3_PUBKEY_AGGREGATE_HPP

#include <nil/crypto3/pubkey/pubkey_value.hpp>
#include <nil/crypto3/pubkey/pubkey_state.hpp>

#include <nil/crypto3/pubkey/operations/aggregate_op.hpp>

#include <nil/crypto3/pubkey/modes/isomorphic.hpp>

namespace nil {
    namespace crypto3 {
        namespace pubkey {
            /*!
             * @brief
             *
             * @ingroup pubkey_algorithms
             *
             * Given a list of signatures for a list of messages and public keys, an aggregation algorithm
             * generates one signature that authenticates the same list of messages and public keys.
             *
             *
             *
             */
            template<typename Scheme>
            using aggregation_policy = typename pubkey::modes::isomorphic<Scheme>::aggregation_policy;
        }    // namespace pubkey

        /*!
         * @brief
         *
         * @ingroup pubkey_algorithms
         *
         * @tparam Scheme
         * @tparam InputIterator
         * @tparam OutputIterator
         *
         * @param first
         * @param last
         * @param out
         *
         * @return
         */
        template<typename Scheme, typename InputIterator, typename OutputIterator>
        typename std::enable_if<!boost::accumulators::detail::is_accumulator_set<OutputIterator>::value,
                                OutputIterator>::type
            aggregate(InputIterator first, InputIterator last, OutputIterator out) {

            typedef typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type
                ProcessingMode;
            typedef typename pubkey::aggregation_accumulator_set<ProcessingMode> AggregationAccumulator;

            typedef pubkey::detail::value_pubkey_impl<AggregationAccumulator> StreamSchemeImpl;
            typedef pubkey::detail::itr_pubkey_impl<StreamSchemeImpl, OutputIterator> SchemeImpl;

            return SchemeImpl(first, last, std::move(out), AggregationAccumulator());
        }

        /*!
         * @brief
         *
         * @ingroup pubkey_algorithms
         *
         * @tparam Scheme
         * @tparam SinglePassRange
         * @tparam OutputIterator
         *
         * @param rng
         * @param out
         *
         * @return
         */
        template<typename Scheme, typename SinglePassRange, typename OutputIterator>
        typename std::enable_if<!boost::accumulators::detail::is_accumulator_set<OutputIterator>::value,
                                OutputIterator>::type
            aggregate(const SinglePassRange &rng, OutputIterator out) {

            typedef typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type
                ProcessingMode;
            typedef typename pubkey::aggregation_accumulator_set<ProcessingMode> AggregationAccumulator;

            typedef pubkey::detail::value_pubkey_impl<AggregationAccumulator> StreamSchemeImpl;
            typedef pubkey::detail::itr_pubkey_impl<StreamSchemeImpl, OutputIterator> SchemeImpl;

            return SchemeImpl(rng, std::move(out), AggregationAccumulator());
        }

        /*!
         * @brief
         *
         * @ingroup pubkey_algorithms
         *
         * @tparam Scheme
         * @tparam InputIterator
         * @tparam OutputAccumulator
         *
         * @param first
         * @param last
         * @param acc
         *
         * @return
         */
        template<
            typename Scheme, typename InputIterator,
            typename OutputAccumulator = typename pubkey::aggregation_accumulator_set<
                typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type>>
        typename std::enable_if<boost::accumulators::detail::is_accumulator_set<OutputAccumulator>::value,
                                OutputAccumulator>::type &
            aggregate(InputIterator first, InputIterator last, OutputAccumulator &acc) {

            typedef pubkey::detail::ref_pubkey_impl<OutputAccumulator> StreamSchemeImpl;
            typedef pubkey::detail::range_pubkey_impl<StreamSchemeImpl> SchemeImpl;

            return SchemeImpl(first, last, std::forward<OutputAccumulator>(acc));
        }

        /*!
         * @brief
         *
         * @ingroup pubkey_algorithms
         *
         * @tparam Scheme
         * @tparam SinglePassRange
         * @tparam OutputAccumulator
         *
         * @param r
         * @param acc
         *
         * @return
         */
        template<typename Scheme, typename SinglePassRange,
                 typename OutputAccumulator =
                     typename pubkey::aggregation_accumulator_set<typename pubkey::modes::isomorphic<
                         Scheme>::template bind<typename pubkey::modes::isomorphic<Scheme>::signing_policy>::type>>
        typename std::enable_if<boost::accumulators::detail::is_accumulator_set<OutputAccumulator>::value,
                                OutputAccumulator>::type &
            aggregate(const SinglePassRange &r, OutputAccumulator &acc) {

            typedef pubkey::detail::ref_pubkey_impl<OutputAccumulator> StreamSchemeImpl;
            typedef pubkey::detail::range_pubkey_impl<StreamSchemeImpl> SchemeImpl;

            return SchemeImpl(r, std::forward<OutputAccumulator>(acc));
        }

        /*!
         * @brief
         *
         * @ingroup pubkey_algorithms
         *
         * @tparam Scheme
         * @tparam InputIterator
         * @tparam AggregationAccumulator
         *
         * @param first
         * @param last
         *
         * @return
         */
        template<
            typename Scheme, typename InputIterator,
            typename AggregationAccumulator = typename pubkey::aggregation_accumulator_set<
                typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type>>
        pubkey::detail::range_pubkey_impl<pubkey::detail::value_pubkey_impl<AggregationAccumulator>>
            aggregate(InputIterator first, InputIterator last) {

            typedef typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type
                ProcessingMode;

            typedef pubkey::detail::value_pubkey_impl<AggregationAccumulator> StreamSchemeImpl;
            typedef pubkey::detail::range_pubkey_impl<StreamSchemeImpl> SchemeImpl;

            return SchemeImpl(first, last, AggregationAccumulator());
        }

        /*!
         * @brief
         *
         * @ingroup pubkey_algorithms
         *
         * @tparam Scheme
         * @tparam SinglePassRange
         * @tparam AggregationAccumulator
         *
         * @param r
         *
         * @return
         */
        template<
            typename Scheme, typename SinglePassRange,
            typename AggregationAccumulator = typename pubkey::aggregation_accumulator_set<
                typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type>>
        pubkey::detail::range_pubkey_impl<pubkey::detail::value_pubkey_impl<AggregationAccumulator>>
            aggregate(const SinglePassRange &r) {

            typedef typename pubkey::modes::isomorphic<Scheme>::template bind<pubkey::aggregation_policy<Scheme>>::type
                ProcessingMode;

            typedef pubkey::detail::value_pubkey_impl<AggregationAccumulator> StreamSchemeImpl;
            typedef pubkey::detail::range_pubkey_impl<StreamSchemeImpl> SchemeImpl;

            return SchemeImpl(r, AggregationAccumulator());
        }
    }    // namespace crypto3
}    // namespace nil

#endif    // CRYPTO3_PUBKEY_AGGREGATE_HPP