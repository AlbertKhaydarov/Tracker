//
//  UserDefaultsStorage.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 04.02.2024.
//

import Foundation

enum StorageKeys: String {
    case timeSheetStorageKey
}

final class UserDefaultsStorage: UserDefaultsStorageProtocol {
    static let shared =  UserDefaultsStorage()
    private let storage = UserDefaults.standard
    
    private init() {}
    
    var timeSheetStorage: [Int]? {
        get {
            storage.array(forKey: StorageKeys.timeSheetStorageKey.rawValue) as? [Int]
        }
        set {
            storage.set(newValue, forKey: StorageKeys.timeSheetStorageKey.rawValue)
        }
    }
}

