//
//  ArrayMarshalling.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 14.02.2024.
//

import Foundation

final class ArrayMarshalling {
    func transformedValue(_ value: [Int]) -> NSData? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            return data as NSData
        } catch {
            assertionFailure("Failed to transform to Data \(CoreDataErrors.transformError(error))")
            return nil
        }
    }
    
    func reverseTransformedValue(_ value: Data?) -> [Int] {
        guard let data = value else { return []}
        do {
            let time = (try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSMutableArray.self, NSNumber.self], from: data) as? [Int])!
            return time
        } catch {
            assertionFailure("Failed to transform to [Int] \(CoreDataErrors.transformError(error))")
            return []
        }
    }
}
