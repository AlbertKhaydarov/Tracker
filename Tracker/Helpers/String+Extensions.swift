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
        switch weekDay {
        case 1: return "Вс"
        case 2: return "Пн"
        case 3: return "Вт"
        case 4: return "Ср"
        case 5: return "Чт"
        case 6: return "Пт"
        case 7: return "Сб"
        default: break
        }
        return "Weekday"
    }
}
