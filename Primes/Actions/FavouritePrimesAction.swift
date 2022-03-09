import SwiftUI

enum FavouritePrimesAction {
    case deleteFavouritePrimes(IndexSet)
    
    var deleteFavouritePrimes: IndexSet? {
        get {
            guard case let .deleteFavouritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .deleteFavouritePrimes = self, let newValue = newValue else { return }
            self = .deleteFavouritePrimes(newValue)
        }
    }
}
