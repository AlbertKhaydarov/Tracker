//
//  Tracker.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 10.01.2024.
//

import UIKit

struct TrackerModel {
    let id: UUID
    let name: String
    let color: UIColor
//    let emojie: String
    let timesheet: [Timesheet]
}

struct Timesheet {
    let weekday: Weekday
}

enum Weekday: String {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}
