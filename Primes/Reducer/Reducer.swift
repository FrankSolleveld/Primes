import SwiftUI
import ComposableArchitecture
import FavouritePrimes
import Counter
import PrimeModal

func activityFeed(
    _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        switch action {
        case .counterView(.counter):
            break
        case .counterView(.primeModal(.removeFavouritePrimeTapped)):
            state.activityFeed.append(.init(timestamp: Date(), type: .removedFavouritePrime(state.count)))
        case .counterView(.primeModal(.saveFavouritePrimeTapped)):
            state.activityFeed.append(.init(timestamp: Date(), type: .addedFavouritePrime(state.count)))
        case let .favouritePrimes(.deleteFavouritePrimes(indexSet)):
            for index in indexSet {
                state.activityFeed.append(.init(timestamp: Date(), type: .removedFavouritePrime(state.favouritePrimes[index])))
            }
        }
        reducer(&state, action)
    }
}

let _appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(counterViewReducer, value: \.counterView, action: \.counterView),
    pullback(favouritePrimesReducer, value: \.favouritePrimes, action: \.favouritePrimes)
)
let appReducer = pullback(_appReducer, value: \.self, action: \.self)

struct _KeyPath<Root, Value> {
    let get: (Root) -> Value
    let set: (inout Root, Value) -> Void
}

struct EnumKeyPath<Root, Value> {
    let embed: (Value) -> Root
    let extract: (Root) -> Value?
}
