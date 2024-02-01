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
    let emoji: String
    let timesheet: [Int]?
}
