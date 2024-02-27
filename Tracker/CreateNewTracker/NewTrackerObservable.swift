//
//  Observable.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 27.02.2024.
//

import Foundation
class NewTrackerObservable<T> {
//    var value: T? {
//        didSet {
//            listener?(value)
//        }
//    }
//    
//    init(value: T?) {
//        self.value = value
//    }
    
//    private var listener: ((T?) -> Void)?
//    
//    func bind(_ listener: @escaping (T?) -> Void) {
//        listener(value)
//        self.listener = listener
//    }
    
    var value: T? {
        didSet {
            listeners.forEach { $0(value) }
        }
    }
    
    init(value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?) -> Void)] = []
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
}
