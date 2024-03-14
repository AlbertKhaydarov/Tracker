//
//  TypeAction.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 14.03.2024.
//

import Foundation

enum TypeCategories {
    case newType
    case existingType
}

extension TypeCategories {
    func localizedString() -> String {
        switch self {
        case .newType:
            return NSLocalizedString("newCategoryTypeVC.title", comment: "")
        case .existingType:
            return NSLocalizedString("editCategoryType.title", comment: "")
        }
    }
}
