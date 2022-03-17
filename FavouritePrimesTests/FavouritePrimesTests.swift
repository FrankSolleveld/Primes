//
//  FavouritePrimesTests.swift
//  FavouritePrimesTests
//
//  Created by Frank Solleveld on 09/03/2022.
//

import XCTest
@testable import FavouritePrimes

class FavouritePrimesTests: XCTestCase {
    func testDeleteFavouritePrimesTapped() {
        var state = [2, 3, 4, 5]
        let effects = favouritePrimesReducer(state: &state, action: .deleteFavouritePrimes([2]))
        XCTAssertEqual(state, [2, 3, 5])
        XCTAssert(effects.isEmpty)
    }

    func testSaveFavouritePrimesTapped() {
        var state = [2, 3, 4, 5]
        let effects = favouritePrimesReducer(state: &state, action: .saveButtonTapped)
        XCTAssertEqual(state, [2, 3, 4, 5])
        XCTAssertEqual(effects.count, 1)
    }

    func testLoadFavouritePrimesFlow() {
        var state = [2, 3, 4, 5]
        var effects = favouritePrimesReducer(state: &state, action: .loadButtonTapped)
        XCTAssertEqual(state, [2, 3, 4, 5])
        XCTAssertEqual(effects.count, 1)
    
        effects = favouritePrimesReducer(state: &state, action: .loadedFavouritePrimes([2, 3, 1]))
        XCTAssertEqual(state, [2, 3, 1])
        XCTAssert(effects.isEmpty)
    }
}
