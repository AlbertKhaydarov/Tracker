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
        case 1: return "Пн"
        case 2: return "Вт"
        case 3: return "Ср"
        case 4: return "Чт"
        case 5: return "Пт"
        case 6: return "Сб"
        case 7: return "Вс"
        default: break
        }
        return "Weekday"
    }
    
    func shortDays(for weekDay: String) -> Int {
        switch weekDay {
        case "Понедельник": return 1
        case "Вторник": return 2
        case "Среда": return 3
        case "Четверг": return 4
        case "Пятница": return 5
        case "Суббота": return 6
        case "Воскресенье": return 7
        default: return 100
        }
    }
}
