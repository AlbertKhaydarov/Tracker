//
//  PropertyWrapper.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 14.03.2024.
//

import Foundation

@propertyWrapper
final class PropertyWrapper<Value> {

    private var onChange: ((Value) -> Void)? = nil

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: PropertyWrapper {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
