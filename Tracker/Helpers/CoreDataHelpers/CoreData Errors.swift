//
//  CoreData Errors.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import Foundation

enum CoreDataErrors: Error {
    case decodingError(Error)
    case codeError(Error)
    case transformError(Error)
    case persistentStoreError(Error)
    case fetchError(Error)
    case saveError(Error)
    case deleteError(Error)
    case creatError(Error)
    case validationError(Error)
    case migrationError(Error)
    case unknownError(Error)
}
