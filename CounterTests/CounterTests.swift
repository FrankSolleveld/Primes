//
//  CounterTests.swift
//  CounterTests
//
//  Created by Frank Solleveld on 09/03/2022.
//

import XCTest
@testable import Counter

class CounterTests: XCTestCase {
    func testIncrTapped() {
        var state = CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        )
        let effects = counterViewReducer(&state, .counter(.incrTapped))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: nil,
            count: 3,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        ))
        XCTAssert(effects.isEmpty)
    }

    func testDecrTapped() {
        var state = CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        )
        let effects = counterViewReducer(&state, .counter(.decrTapped))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: nil,
            count: 1,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        ))
        XCTAssert(effects.isEmpty)
    }

    func testNthPrimeResponseHappyFlow() {
        var state = CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        )
        var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: true
        ))
        XCTAssertEqual(effects.count, 1)

        effects = counterViewReducer(&state, .counter(.nthPrimeResponse(3)))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: PrimeAlert(prime: 3),
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        ))
        XCTAssert(effects.isEmpty)

        effects = counterViewReducer(&state, .counter(.alertDismissButtonTapped))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        ))
        XCTAssert(effects.isEmpty)
    }

    func testNthPrimeResponseAngryFlow() {
        var state = CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        )
        var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: true
        ))
        XCTAssertEqual(effects.count, 1)

        effects = counterViewReducer(&state, .counter(.nthPrimeResponse(nil)))
        XCTAssertEqual(state, CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [2, 5],
            isNthPrimeButtonDisabled: false
        ))
        XCTAssert(effects.isEmpty)
    }

    func testPrimeModal() {
        var state = CounterViewState(
            alertNthPrime: nil,
            count: 2,
            favouritePrimes: [7, 11],
            isNthPrimeButtonDisabled: false
        )
        var effects = counterViewReducer(&state, .primeModal(.saveFavouritePrimeTapped))
        XCTAssertEqual(
            state,
            CounterViewState(
                alertNthPrime: nil,
                count: 2,
                favouritePrimes: [7, 11, 2],
                isNthPrimeButtonDisabled: false
            )
        )
        XCTAssert(effects.isEmpty)

        effects = counterViewReducer(&state, .primeModal(.removeFavouritePrimeTapped))
        XCTAssertEqual(
            state,
            CounterViewState(
                alertNthPrime: nil,
                count: 2,
                favouritePrimes: [7, 11],
                isNthPrimeButtonDisabled: false
            )
        )
        XCTAssert(effects.isEmpty)
    }
}
