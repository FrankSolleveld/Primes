import SwiftUI
import ComposableArchitecture
import FavouritePrimes
import Counter

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Counter Demo",
                    destination: CounterView(
                        store: store
                            .view(
                                value: {( $0.count, $0.favouritePrimes )},
                                action: {
                                    switch $0 {
                                    case let .counter(action):
                                        return AppAction.counter(action)
                                    case let .primeModal(action):
                                        return AppAction.primeModal(action)
                                    }
                                }
                            )
                    )
                )
                NavigationLink(
                    "Favorite primes",
                    destination: FavouritePrimesView(
                        store: store
                            .view(
                                value: { $0.favouritePrimes },
                                action: { .favouritePrimes($0) }
                            )
                    )
                )
            }
            .navigationTitle("Primes")
        }
    }
}
