//
//  Observable.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 27.02.2024.
//

import Foundation
final class NewTrackerObservable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
