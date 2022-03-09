import SwiftUI

final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    @Published private(set) var value: Value
    
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    func send(_ action: Action) {
        self.reducer(&self.value, action)
    }
}

func logging<Value, Action>(
    _ reducer: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print("Value: \(value)")
        dump(value)
        print("---")
    }
}
