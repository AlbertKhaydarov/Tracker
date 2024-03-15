//
//  TypeAction.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 14.03.2024.
//

import Foundation

enum FiltersTypes: Int, CaseIterable {
    case allTrackers
    case todayTrackers
    case completedTrackers
    case uncompletedTrackers
}

extension FiltersTypes {
    func localizedString() -> String {
        switch self {
        case .allTrackers:
            return NSLocalizedString("allTrackers.filter", comment: "")
        case .todayTrackers:
            return NSLocalizedString("todayTrackers.filter", comment: "")
        case .completedTrackers:
            return NSLocalizedString("completedTrackers.filter", comment: "")
        case .uncompletedTrackers:
            return NSLocalizedString("uncompletedTrackers.filter", comment: "")
        }
    }
}

