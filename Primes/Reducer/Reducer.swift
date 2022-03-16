import SwiftUI
import ComposableArchitecture
import FavouritePrimes
import Counter
import PrimeModal

func activityFeed(
    _ reducer: @escaping Reducer<AppState, AppAction>
) -> Reducer<AppState, AppAction> {
    return { state, action in
        switch action {
        case .counterView(.counter),
             .favouritePrimes(.loadedFavouritePrimes),
             .favouritePrimes(.saveButtonTapped),
             .favouritePrimes(.loadButtonTapped):
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
        return reducer(&state, action)
    }
}

let appReducer = combine(
  pullback(counterViewReducer, value: \AppState.counterView, action: \AppAction.counterView),
  pullback(favouritePrimesReducer, value: \.favouritePrimes, action: \.favouritePrimes)
)

struct _KeyPath<Root, Value> {
    let get: (Root) -> Value
    let set: (inout Root, Value) -> Void
}

struct EnumKeyPath<Root, Value> {
    let embed: (Value) -> Root
    let extract: (Root) -> Value?
}
