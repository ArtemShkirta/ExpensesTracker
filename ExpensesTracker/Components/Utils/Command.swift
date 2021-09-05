//
//  Command.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

struct Command<Value> {
    typealias Action = (Value) -> Void
    private let action: Action

    init(_ action: @escaping Action) {
        self.action = action
    }

    func perform(value: Value) {
        action(value)
    }
}

extension Command where Value == Void {
    func perform() {
        perform(value: ())
    }
}
