//
//  FavouritePrimes.swift
//  FavouritePrimes
//
//  Created by Frank Solleveld on 09/03/2022.
//

import SwiftUI
import ComposableArchitecture

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

public struct FavouritePrimesView: View {

    public init(store: Store<[Int], FavouritePrimesAction>) {
        self.store = store
    }

    @ObservedObject var store: Store<[Int], FavouritePrimesAction>

    public var body: some View {
        List {
            ForEach(store.value, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                store.send(.deleteFavouritePrimes(indexSet))
            }
        }
        .navigationTitle("Favourite Primes")
    }
}
