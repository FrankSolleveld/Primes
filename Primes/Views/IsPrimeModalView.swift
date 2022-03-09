import SwiftUI

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        VStack {
            if isPrime(2) {
                Text("\(self.store.value.count) is prime 🎉")
                if self.store.value.favouritePrimes.contains(self.store.value.count) {
                    Button("Remove from favorite primes") {
                        self.store.send(.primeModal(.removeFavouritePrimeTapped))
                    }
                } else {
                    Button("Save to favorite primes") {
                        self.store.send(.primeModal(.saveFavouritePrimeTapped))
                    }
                }
            } else {
                Text("\(self.store.value.count) is not prime :(")
            }
        }
    }
}
