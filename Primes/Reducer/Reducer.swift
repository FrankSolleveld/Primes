import SwiftUI

func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
        case .decrTapped:
        state -= 1
        case .incrTapped:
        state += 1
    }
}

func primeModalReducer(state: inout AppState, action: PrimeModalAction) -> Void {
    switch action {
    case .removeFavouritePrimeTapped:
        state.favouritePrimes.removeAll(where: { $0 == state.count })
        
    case .saveFavouritePrimeTapped:
        state.favouritePrimes.append(state.count)
    }
}

func favouritePrimesReducer(state: inout [Int], action: FavouritePrimesAction) -> Void {
    switch action {
    case let .deleteFavouritePrimes(indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

func activityFeed(
    _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        switch action {
        case .counter:
            break
        case .primeModal(.removeFavouritePrimeTapped):
            state.activityFeed.append(.init(timestamp: Date(), type: .removedFavouritePrime(state.count)))
        case .primeModal(.saveFavouritePrimeTapped):
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
    pullback(counterReducer, value: \.count, action: \.counter),
    pullback(primeModalReducer, value: \.self, action: \.primeModal),
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
