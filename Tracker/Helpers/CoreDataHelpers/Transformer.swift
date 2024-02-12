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
        let data = try? JSONEncoder().encode(days)
        print("data", data)
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        let time = try? JSONDecoder().decode([Int].self, from: data)
        
        print("time", time)
        return time
    }
    
    static func register() {
        let transformer = TimeSheetDaysValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(String(describing: type(of: transformer))))
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
