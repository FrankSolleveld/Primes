//
//  Counter.swift
//  Counter
//
//  Created by Frank Solleveld on 09/03/2022.
//

import SwiftUI
import ComposableArchitecture
import PrimeModal

public enum CounterAction {
    case decrTapped
    case incrTapped
}

public func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
        case .decrTapped:
        state -= 1
        case .incrTapped:
        state += 1
    }
}

public let counterViewReducer:  = combine(
    pullback(counterReducer, value: \.count, action: \.counter),
    pullback(primeModalReducer, value: \.self, action: \.primeModal)
)

struct PrimeAlert: Identifiable {
    let prime: Int
    var id: Int { self.prime }
}

public typealias CounterViewState = (count: Int, favouritePrimes: [Int])

public enum CounterViewAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)

    var counter: CounterAction? {
      get {
        guard case let .counter(value) = self else { return nil }
        return value
      }
      set {
        guard case .counter = self, let newValue = newValue else { return }
        self = .counter(newValue)
      }
    }

    var primeModal: PrimeModalAction? {
      get {
        guard case let .primeModal(value) = self else { return nil }
        return value
      }
      set {
        guard case .primeModal = self, let newValue = newValue else { return }
        self = .primeModal(newValue)
      }
    }
}

public struct CounterView: View {

    public init(store: Store<CounterViewState, CounterViewAction>) {
        self.store = store
    }

    @ObservedObject var store: Store<CounterViewState, CounterViewAction>
    @State var isPrimeModalShown = false
    @State var alertNthPrime: PrimeAlert?
    @State var isNthPrimeButtonDisabled = false
    public var body: some View {
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
            IsPrimeModalView(
                store: store
                    .view(
                        value: {( $0.count, $0.favouritePrimes )},
                        action: { .primeModal($0) }
                    )
            )
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

func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

func nthPrime(_ n: Int, callback: @escaping (Int?) -> Void) -> Void {
    wolframAlpha(query: "prime \(n)") { result in
        callback(
            result
                .flatMap {
                    $0.queryresult
                        .pods
                        .first(where: { $0.primary == .some(true) })?
                        .subpods
                        .first?
                        .plaintext
                }
                .flatMap(Int.init)
        )
    }
}
