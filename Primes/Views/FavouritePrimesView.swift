import SwiftUI
import ComposableArchitecture

struct FavouritePrimesView: View {
    @ObservedObject var store: Store<[Int], AppAction>
    var body: some View {
        List {
            ForEach(store.value, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in 
                store.send(.favouritePrimes(.deleteFavouritePrimes(indexSet)))
            }
        }
        .navigationTitle("Favourite Primes")
    }
}
