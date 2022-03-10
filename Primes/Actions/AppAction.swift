import SwiftUI
import FavouritePrimes
import Counter
import PrimeModal

enum AppAction {
    case counterView(CounterViewAction)
    case favouritePrimes(FavouritePrimesAction)

    var counterView: CounterViewAction? {
        get {
            guard case let .counterView(value) = self else { return nil }
            return value
        }
        set {
            guard case .counterView = self, let newValue = newValue else { return }
            self = .counterView(newValue)
        }
    }

    var favouritePrimes: FavouritePrimesAction? {
        get {
            guard case let .favouritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .favouritePrimes = self, let newValue = newValue else { return }
            self = .favouritePrimes(newValue)
        }
    }
}
