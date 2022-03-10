import SwiftUI
import ComposableArchitecture
import FavouritePrimes

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
                                action: { $0 }
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
