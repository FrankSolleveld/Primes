import SwiftUI
import PrimeModal
import Counter

struct AppState {
    var count = 0
    var favouritePrimes = [Int]()
    var loggedInUser: User? = nil
    var activityFeed = [Activity]()
    var alertNthPrime: PrimeAlert? = nil
    var isNthPrimeButtonDisabled: Bool = false
    
    struct Activity {
        let timestamp: Date
        let type: ActivityType

        enum ActivityType {
            case addedFavouritePrime(Int)
            case removedFavouritePrime(Int)

            var addedFavouritePrime: Int? {
                get {
                    guard case let .addedFavouritePrime(value) = self else { return nil }
                    return value
                }
                set {
                    guard case .addedFavouritePrime = self, let newValue = newValue else { return }
                    self = .addedFavouritePrime(newValue)
                }
            }
            var removedFavouritePrime: Int? {
                get {
                    guard case let .removedFavouritePrime(value) = self else { return nil }
                    return value
                }
                set {
                    guard case .removedFavouritePrime = self, let newValue = newValue else { return }
                    self = .removedFavouritePrime(newValue)
                }
            }
        }
    }

    struct User {
        let id: Int
        let name: String
        let bio: String
    }
}

extension AppState {
    var counterView: CounterViewState {
        get {
            CounterViewState(
                alertNthPrime: self.alertNthPrime,
                count: self.count,
                favouritePrimes: self.favouritePrimes,
                isNthPrimeButtonDisabled: self.isNthPrimeButtonDisabled
            )
        }
        set {
            self.alertNthPrime = newValue.alertNthPrime
            self.count = newValue.count
            self.favouritePrimes = newValue.favouritePrimes
            self.isNthPrimeButtonDisabled = newValue.isNthPrimeButtonDisabled
        }
    }
}
