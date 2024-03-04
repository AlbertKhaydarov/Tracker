//
//  WeekDay.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import Foundation

// enum WeekDays: String, CaseIterable {
//    case monday = "Понедельник"
//    case tuesday = "Вторник"
//    case wednesday = "Среда"
//    case thursday = "Четверг"
//    case friday = "Пятница"
//    case saturday = "Суббота"
//    case sunday = "Воскресенье"
//    static let allDaysCount = WeekDays.allCases.count
//}

enum WeekDays: String, CaseIterable {
    case monday = "weekDay2"
    case tuesday = "weekDay3"
    case wednesday = "weekDay4"
    case thursday = "weekDay5"
    case friday = "weekDay6"
    case saturday = "weekDay7"
    case sunday = "weekDay1"
    
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
