import SwiftUI

enum AppAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    case favouritePrimes(FavouritePrimesAction)
    
    var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }
    
    var primeModal: PrimeModalAction? {
        get {
            guard case let .primeModal(value) = self else { return nil }
            return value
        }
        set {
            guard case .primeModal = self, let newValue = newValue else { return }
            self = .primeModal(newValue)
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
