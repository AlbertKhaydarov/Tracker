//
//  Transformer.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import Foundation
import CoreData

//@objc
//class TimeSheetDaysValueTransformer: ValueTransformer {
//    override class func transformedValueClass() -> AnyClass {return NSArray.self}
//    
//    override class func allowsReverseTransformation() -> Bool {true}
//    
//    override func transformedValue(_ value: Any?) -> Any? {
//        guard let intArray = value as? [Int] else {return nil}
//        return intArray as NSArray
//    }
//    override func reverseTransformedValue(_ value: Any?) -> Any? {
//           guard let nsArray = value as? NSArray else {return nil}
//           return nsArray as? [Int]
//       }
//
//    static let timeSheetDaysValueTransformer = NSValueTransformerName(rawValue: "TimeSheetDaysValueTransformer")
//
//static func register() {
//    let transformer = TimeSheetDaysValueTransformer()
////    ValueTransformer.setValueTransformer(transformer, forName: timeSheetDaysValueTransformer)
//    ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(String(describing: type(of: transformer))))
//}
//}

@objc
final class TimeSheetDaysValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Int] else { return nil }
        let data = try? JSONEncoder().encode(days)
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        let time = try? JSONDecoder().decode([Int].self, from: data)
        return time
    }
    
    static func register() {
        let transformer = TimeSheetDaysValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(String(describing: type(of: transformer))))
    }
}
