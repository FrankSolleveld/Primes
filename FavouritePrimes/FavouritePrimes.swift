//
//  FavouritePrimes.swift
//  FavouritePrimes
//
//  Created by Frank Solleveld on 09/03/2022.
//

import SwiftUI

public enum FavouritePrimesAction {
    case deleteFavouritePrimes(IndexSet)
}

public func favouritePrimesReducer(state: inout [Int], action: FavouritePrimesAction) -> Void {
    switch action {
    case let .deleteFavouritePrimes(indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}
