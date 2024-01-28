//
//  WeekDay.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import Foundation

 enum WeekDays: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    static let numberOfDays = WeekDays.allCases.count
}
