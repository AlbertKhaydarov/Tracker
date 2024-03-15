//
//  UserDefaultsStorage.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 04.02.2024.
//

import Foundation

enum StorageKeys: String {
    case timeSheetStorageKey
    case isFirstLaunchKey
    case lastSelectedcategory
    case lastSelectedFilter
}

final class UserDefaultsStorage: UserDefaultsStorageProtocol {
    static let shared =  UserDefaultsStorage()
    private let storage = UserDefaults.standard
    
    private init() {
            if storage.object(forKey: StorageKeys.isFirstLaunchKey.rawValue) == nil {
                storage.set(true, forKey: StorageKeys.isFirstLaunchKey.rawValue)
            }
        }

    var timeSheetStorage: [Int]? {
        get {
            storage.array(forKey: StorageKeys.timeSheetStorageKey.rawValue) as? [Int]
        }
        set {
            storage.set(newValue, forKey: StorageKeys.timeSheetStorageKey.rawValue)
        }
    }
   
      var isFirstLaunch: Bool {
          get {
              return storage.bool(forKey: StorageKeys.isFirstLaunchKey.rawValue)
          }
          set {
              storage.set(newValue, forKey: StorageKeys.isFirstLaunchKey.rawValue)
          }
      }
    
    var lastSelectedcategory: Int {
        get {
            return storage.integer(forKey: StorageKeys.lastSelectedcategory.rawValue)
        }
        set {
            storage.set(newValue, forKey: StorageKeys.lastSelectedcategory.rawValue)
        }
    }
    
    var lastSelectedFilter: Int {
        get {
            return storage.integer(forKey: StorageKeys.lastSelectedFilter.rawValue)
        }
        set {
            storage.set(newValue, forKey: StorageKeys.lastSelectedFilter.rawValue)
        }
    }
}

