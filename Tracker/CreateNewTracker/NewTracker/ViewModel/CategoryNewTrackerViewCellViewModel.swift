//
//  NewTrackerCellViewModel.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 27.02.2024.
//

import Foundation

class CategoryNewTrackerViewCellViewModel: Identifiable {
    
//    let id: String
    var selectedCategory: String


    init( /*id: String,*/ selectedCategory: String) {
//        self.id = id
        self.selectedCategory = selectedCategory
//        self.weekdays = weekdays
    }
}
