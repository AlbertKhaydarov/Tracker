//
//  TimeSheetNewTrackerViewCellViewModel.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 27.02.2024.
//

import Foundation

final class TimeSheetNewTrackerViewCellViewModel: Identifiable {
    
    var timeSheetDays: String
    var weekdays: [Int]
    
    init( timeSheetDays: String, weekdays: [Int]) {
        self.timeSheetDays = timeSheetDays
        self.weekdays = weekdays
    }
}
