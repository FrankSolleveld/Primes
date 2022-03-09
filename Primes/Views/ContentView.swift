import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Counter Demo",
                    destination: CounterView(store: store)
                )
                NavigationLink(
                    "Favorite primes",
                    destination: FavouritePrimesView(store: store)
                )
            }
            .navigationTitle("Primes")
        }
    }
}
