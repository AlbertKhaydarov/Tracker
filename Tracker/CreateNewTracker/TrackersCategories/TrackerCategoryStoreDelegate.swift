//
//  TrackerCategoryStoreDelegate.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore)
}
