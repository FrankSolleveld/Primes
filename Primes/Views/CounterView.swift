import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    @State var isPrimeModalShown = false
    @State var alertNthPrime: PrimeAlert?
    @State var isNthPrimeButtonDisabled = false
    var body: some View {
        VStack {
            HStack {
                Button("-") {
                    store.send(.counter(.decrTapped))
                }
                Text("\(store.value.count)")
                Button("+") {
                    store.send(.counter(.incrTapped))
                }
            }
            Button("Is this prime?") {
                isPrimeModalShown = true
            }
            Button(
                "What is the \(ordinal(store.value.count)) prime?",
                action: nthPrimeButtonAction
            )
                .disabled(isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationBarTitle("Counter Demo")
        .sheet(isPresented: $isPrimeModalShown) {
            IsPrimeModalView(store: store)
        }
        .alert(item: $alertNthPrime) { alert in 
            Alert(
                title: Text("The \(ordinal(store.value.count)) prime is \(alert.prime)"),
                dismissButton: .default(Text("Aight"))
            )
        }
    }
    func nthPrimeButtonAction() {
        self.isNthPrimeButtonDisabled = true
        nthPrime(self.store.value.count) { prime in
            self.alertNthPrime = prime.map(PrimeAlert.init(prime:))
            self.isNthPrimeButtonDisabled = false
        }
    }
}
