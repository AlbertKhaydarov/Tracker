//
//  WeekDay.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import Foundation

enum WeekDays: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static let allDaysCount = WeekDays.allCases.count
    
    func localizedString() -> String {
        switch self {
        case .monday:
            return NSLocalizedString("weekDay2", comment: "")
        case .tuesday:
            return NSLocalizedString("weekDay3", comment: "")
        case .wednesday:
            return NSLocalizedString("weekDay4", comment: "")
        case .thursday:
            return NSLocalizedString("weekDay5", comment: "")
        case .friday:
            return NSLocalizedString("weekDay6", comment: "")
        case .saturday:
            return NSLocalizedString("weekDay7", comment: "")
        case .sunday:
            return NSLocalizedString("weekDay1", comment: "")
        }
    }
}
