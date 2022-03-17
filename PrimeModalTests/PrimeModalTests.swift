//
//  PrimeModalTests.swift
//  PrimeModalTests
//
//  Created by Frank Solleveld on 09/03/2022.
//

import XCTest
@testable import PrimeModal

class PrimeModalTests: XCTestCase {
    func testSaveFavouritePrimesTapped() {
        var state = (count: 2, favouritePrimes: [3, 5])
        let effects = primeModalReducer(
            state: &state,
            action: PrimeModalAction.saveFavouritePrimeTapped
        )
        let (count, favouritePrimes) = state
        XCTAssertEqual(count, 2)
        XCTAssertEqual(favouritePrimes, [3, 5, 2])
        XCTAssert(effects.isEmpty)
    }

    func testRemoveFavouritePrimesTapped() {
        var state = (count: 2, favouritePrimes: [3, 5])
        let effects = primeModalReducer(
            state: &state,
            action: .removeFavouritePrimeTapped
        )
        let (count, favouritePrimes) = state
        XCTAssertEqual(count, 2)
        XCTAssertEqual(favouritePrimes, [3, 5])
        XCTAssert(effects.isEmpty)
    }
}
