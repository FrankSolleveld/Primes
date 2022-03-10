//
//  PrimeModal.swift
//  PrimeModal
//
//  Created by Frank Solleveld on 09/03/2022.
//

import SwiftUI
import ComposableArchitecture

public typealias PrimeModalState = (count: Int, favouritePrimes: [Int])

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

public struct IsPrimeModalView: View {

    public init(store: Store<PrimeModalState, PrimeModalAction>) {
        self.store = store
    }

    @ObservedObject var store: Store<PrimeModalState, PrimeModalAction>

    public var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime 🎉")
                if self.store.value.favouritePrimes.contains(self.store.value.count) {
                    Button("Remove from favorite primes") {
                        store.send(.removeFavouritePrimeTapped)
                    }
                } else {
                    Button("Save to favorite primes") {
                        store.send(.saveFavouritePrimeTapped)
                    }
                }
            } else {
                Text("\(store.value.count) is not prime :(")
            }
        }
    }
}

public func isPrime (_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}
