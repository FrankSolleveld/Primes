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
    case loadedFavouritePrimes([Int])
    case saveButtonTapped
    case loadButtonTapped
}

public func favouritePrimesReducer(state: inout [Int], action: FavouritePrimesAction) -> [Effect<FavouritePrimesAction>] {
    switch action {
    case let .deleteFavouritePrimes(indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
        return []

    case let .loadedFavouritePrimes(favouritePrimes):
        state = favouritePrimes
        return []

    case .saveButtonTapped:
        let state = state
        return [saveEffect(favouritePrimes: state)]

    case .loadButtonTapped:
        return [loadEffect]
    }
}

private func saveEffect(favouritePrimes: [Int]) -> Effect<FavouritePrimesAction> {
    return {
        let data = try! JSONEncoder().encode(favouritePrimes)
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentPath)
        let favouritePrimesUrl = documentsUrl.appendingPathComponent("favourite-primes.json")
        try! data.write(to: favouritePrimesUrl)
        return nil
    }
}

private let loadEffect: Effect<FavouritePrimesAction> =
    {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentPath)
        let favouritePrimesUrl = documentsUrl.appendingPathComponent("favourite-primes.json")
        guard let data = try? Data(contentsOf: favouritePrimesUrl),
              let favouritePrimes = try? JSONDecoder().decode([Int].self, from: data) else { return nil }
        return .loadedFavouritePrimes(favouritePrimes)
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
        .navigationBarItems(
            trailing:
                HStack {
                    Button("Save") {
                        store.send(.saveButtonTapped)
                    }
                    Button("Load") {
                        store.send(.loadButtonTapped)
                    }
                }
        )
    }
}
