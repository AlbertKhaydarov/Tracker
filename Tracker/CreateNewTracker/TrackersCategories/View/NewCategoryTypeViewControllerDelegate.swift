//
//  NewCategoryTypeViewControllerDelegateNewCategoryTypeViewControllerDelegate.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

protocol NewCategoryTypeViewControllerDelegate: AnyObject {
    func addNewCategoryType(with categoryType: String)
}
