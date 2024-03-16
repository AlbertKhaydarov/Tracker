//
//  AnalyticsModel.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 16.03.2024.
//

import Foundation

struct AnalyticsModel {
    struct Events {
        static let open = "open"
        static let close = "close"
        static let click = "click"
    }
    
    struct Screens {
        static let mainScreen = "Main"
        static let appDelegate = "AppDelegate"
        static let category = "CategoriesScreen"
        static let schedule = "ScheduleScreen"
    }
    
    struct Items {
        static let addTracker = "add_track"
        static let trackerCompleted = "track"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
}
