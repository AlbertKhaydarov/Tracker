//
//  TypeEvents.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import Foundation

enum TypeEvents {
    case habitType
    case oneTimeType
    case existingTtype
}

extension TypeEvents {
    func localizedString() -> String {
        switch self {
        case .habitType:
            return NSLocalizedString("habitTypeEvents", comment: "")
        case .oneTimeType:
            return NSLocalizedString("oneTimeTypeEvents", comment: "")
        case .existingTtype:
            return NSLocalizedString("existingTypeEvents", comment: "")
        }
    }
}
