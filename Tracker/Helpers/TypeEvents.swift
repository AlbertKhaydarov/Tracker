//
//  TypeEvents.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import Foundation

enum TypeEvents: String {
    case habitType = "Новая привычка"
    case oneTimeType = "Новое нерегулярное событие"
    
    func localizedString() -> String {
        switch self {
        case .habitType:
            return NSLocalizedString("habitTypeEvents", comment: "")
        case .oneTimeType:
            return NSLocalizedString("oneTimeTypeEvents", comment: "")
        }
    }
}
