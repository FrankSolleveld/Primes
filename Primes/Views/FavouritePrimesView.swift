import SwiftUI

struct FavouritePrimesView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        List {
            ForEach(store.value.favouritePrimes, id: \.self) { prime in 
                Text("\(prime)")
            }
            .onDelete { indexSet in 
                store.send(.favouritePrimes(.deleteFavouritePrimes(indexSet)))
            }
        }
        .navigationTitle("Favourite Primes")
    }
}
