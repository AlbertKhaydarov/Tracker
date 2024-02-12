//
//  Transformer.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import Foundation
import CoreData

@objc
final class TimeSheetDaysValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Int] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Int].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            TimeSheetDaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: TimeSheetDaysValueTransformer.self))
        )
    }
}
//@objc
//    final class TimeSheetDaysValueTransformer: NSSecureUnarchiveFromDataTransformer {
//        static let name = NSValueTransformerName(rawValue: String(describing: TimeSheetDaysValueTransformer.self))
//  
//    override class func transformedValueClass() -> AnyClass { NSData.self }
//    override class func allowsReverseTransformation() -> Bool { true }
//    
//    override func transformedValue(_ value: Any?) -> Any? {
//        guard let days = value as? [Int] else { return nil }
//        return try? NSKeyedArchiver.archivedData(withRootObject: days, requiringSecureCoding: true)
//    }
//    
//    override func reverseTransformedValue(_ value: Any?) -> Any? {
//        guard let data = value as? NSData else { return nil }
//        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSArray.self], from: data as Data)
//    }
//    
////    static func register() {
////        ValueTransformer.setValueTransformer(
////            TimeSheetDaysValueTransformer(),
////            forName: NSValueTransformerName(rawValue: String(describing: TimeSheetDaysValueTransformer.self))
////        )
////    }
//        static func register() {
//            let transformer = TimeSheetDaysValueTransformer()
//            ValueTransformer.setValueTransformer(transformer, forName: name)
//        }
//}
