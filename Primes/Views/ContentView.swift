import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Counter Demo",
                    destination: CounterView(
                        store: store
                            .view {( $0.count, $0.favouritePrimes )}
                    )
                )
                NavigationLink(
                    "Favorite primes",
                    destination: FavouritePrimesView(store: store.view { $0.favouritePrimes })
                )
            }
            .navigationTitle("Primes")
        }
    }
}
