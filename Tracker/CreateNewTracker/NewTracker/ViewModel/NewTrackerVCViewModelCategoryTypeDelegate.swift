//
//  NewTrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

protocol NewTrackerVCViewModelCategoryTypeDelegate: AnyObject {
    func getSelectedCategoryType(_ selectedCategory: String)
//    func getSelectedCategoryType(_ selectedCategory: [CategoryTypeCellViewModel])
}
