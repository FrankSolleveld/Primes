import SwiftUI
import ComposableArchitecture
import PrimeModal

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<PrimeModalState, AppAction>
    var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime 🎉")
                if self.store.value.favouritePrimes.contains(self.store.value.count) {
                    Button("Remove from favorite primes") {
                        store.send(.primeModal(.removeFavouritePrimeTapped))
                    }
                } else {
                    Button("Save to favorite primes") {
                        store.send(.primeModal(.saveFavouritePrimeTapped))
                    }
                }
            } else {
                Text("\(store.value.count) is not prime :(")
            }
        }
    }
}
