//
//  PrimeModal.swift
//  PrimeModal
//
//  Created by Frank Solleveld on 09/03/2022.
//

import SwiftUI

public struct PrimeModalState {
    public var count: Int
    public var favouritePrimes: [Int]
}

public enum PrimeModalAction {
    case saveFavouritePrimeTapped
    case removeFavouritePrimeTapped
}

public func primeModalReducer(state: inout PrimeModalState, action: PrimeModalAction) -> Void {
    switch action {
    case .removeFavouritePrimeTapped:
        state.favouritePrimes.removeAll(where: { $0 == state.count })
        
    case .saveFavouritePrimeTapped:
        state.favouritePrimes.append(state.count)
    }
}
