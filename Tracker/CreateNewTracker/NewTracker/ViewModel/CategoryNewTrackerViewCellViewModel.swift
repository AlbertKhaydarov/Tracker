//
//  NewTrackerCellViewModel.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 27.02.2024.
//

import Foundation

final class CategoryNewTrackerViewCellViewModel: Identifiable {
    
    var selectedCategory: String
    
    init(selectedCategory: String) {
        self.selectedCategory = selectedCategory
    }
}
