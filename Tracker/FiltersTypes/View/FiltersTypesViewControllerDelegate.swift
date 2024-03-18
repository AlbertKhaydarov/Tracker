//
//  FiltersTypesViewControllerDelegate.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 14.03.2024.
//

import Foundation

protocol FiltersTypesViewControllerDelegate: AnyObject {
    func getFiltersType(_ controller: FiltersTypesViewController, selectedFilter: FiltersTypes)
}
