//
//  UserDefaultsStorageProtocol.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 04.02.2024.
//

import Foundation

protocol UserDefaultsStorageProtocol {
  var timeSheetStorage: [Int]? { get set }
}
