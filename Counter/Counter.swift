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
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
    case alertDismissButtonTapped
}

public typealias CounterState = (
    alertNthPrime: PrimeAlert?,
    count: Int,
    isNthPrimeButtonDisabled: Bool
)

public func counterReducer(state: inout CounterState, action: CounterAction) -> [Effect<CounterAction>] {
    switch action {
        case .decrTapped:
        state.count -= 1
        return []
        case .incrTapped:
        state.count += 1
        return []
    case .nthPrimeButtonTapped:
        state.isNthPrimeButtonDisabled = true
        return [
            nthPrime(state.count)
                .map(CounterAction.nthPrimeResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        ]
    case let .nthPrimeResponse(prime):
        state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
        state.isNthPrimeButtonDisabled = false
        return []

    case .alertDismissButtonTapped:
        state.alertNthPrime = nil
        return []
    }
}

public let counterViewReducer = combine(
  pullback(counterReducer, value: \CounterViewState.counter, action: \CounterViewAction.counter),
  pullback(primeModalReducer, value: \.primeModal, action: \.primeModal)
)

public struct PrimeAlert: Identifiable {
    let prime: Int
    public var id: Int { self.prime }
}

public struct CounterViewState {
    public var alertNthPrime: PrimeAlert?
    public var count: Int
    public var favouritePrimes: [Int]
    public var isNthPrimeButtonDisabled: Bool

    public init(
        alertNthPrime: PrimeAlert?,
        count: Int,
        favouritePrimes: [Int],
        isNthPrimeButtonDisabled: Bool
    ) {
        self.alertNthPrime = alertNthPrime
        self.count = count
        self.favouritePrimes = favouritePrimes
        self.isNthPrimeButtonDisabled = isNthPrimeButtonDisabled
    }

    var counter: CounterState {
        get {
            (self.alertNthPrime, self.count, self.isNthPrimeButtonDisabled)
        }
        set {
            (self.alertNthPrime, self.count, self.isNthPrimeButtonDisabled)
            = newValue
        }
    }

    var primeModal: PrimeModalState {
        get {
            (self.count, self.favouritePrimes)
        }
        set {
            (self.count, self.favouritePrimes)
            = newValue
        }
    }
}

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
            .disabled(store.value.isNthPrimeButtonDisabled)
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
        .alert(item: .constant(store.value.alertNthPrime)) { alert in
            Alert(
                title: Text("The \(ordinal(store.value.count)) prime is \(alert.prime)"),
                dismissButton: .default(Text("Cool"), action: {
                    store.send(.counter(.alertDismissButtonTapped))
                })
            )
        }
    }
    func nthPrimeButtonAction() {
        store.send(.counter(.nthPrimeButtonTapped))
    }
}

func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}
