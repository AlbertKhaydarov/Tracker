//
//  String+Extensions.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 11.01.2024.
//

import Foundation

private let dateTimeDefaultFormatterDate: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormatter
}()

extension String {
    var dateTimeDateFromString: Date? { dateTimeDefaultFormatterDate.date(from: self) }
}

private let dateTimeISO8601FormatterDate: ISO8601DateFormatter = {
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter
}()

extension String {
    var dateISO8601TimeDateFromString: Date? {dateTimeISO8601FormatterDate.date(from: self)}
    
    static let emojiesCollection = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    func weekdayFromInt(_ weekDay: Int) -> String {
        let orderDay1 = NSLocalizedString("orderDay1", comment: "")
        let orderDay2 = NSLocalizedString("orderDay2", comment: "")
        let orderDay3 = NSLocalizedString("orderDay3", comment: "")
        let orderDay4 = NSLocalizedString("orderDay4", comment: "")
        let orderDay5 = NSLocalizedString("orderDay5", comment: "")
        let orderDay6 = NSLocalizedString("orderDay6", comment: "")
        let orderDay7 = NSLocalizedString("orderDay7", comment: "")
//        let allWeekDays = NSLocalizedString("allWeekDays", comment: "")
       
        switch weekDay {
        case 1: return orderDay7
        case 2: return orderDay1
        case 3: return orderDay2
        case 4: return orderDay3
        case 5: return orderDay4
        case 6: return orderDay5
        case 7: return orderDay6
        default: break
        }
        return "Weekday"
    }
    
    func shortDays(for weekDay: String) -> Int {
        let weekDay1 = NSLocalizedString("weekDay1", comment: "")
        let weekDay2 = NSLocalizedString("weekDay2", comment: "")
        let weekDay3 = NSLocalizedString("weekDay3", comment: "")
        let weekDay4 = NSLocalizedString("weekDay4", comment: "")
        let weekDay5 = NSLocalizedString("weekDay5", comment: "")
        let weekDay6 = NSLocalizedString("weekDay6", comment: "")
        let weekDay7 = NSLocalizedString("weekDay7", comment: "")
        
        switch weekDay {
        case weekDay1: return 1
        case weekDay2: return 2
        case weekDay3: return 3
        case weekDay4: return 4
        case weekDay5: return 5
        case weekDay6: return 6
        case weekDay7: return 7
        default: return 100
        }
    }
}
