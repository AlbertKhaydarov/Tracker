//
//  NewTrackerVCViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

final class NewTrackerVCViewModel {
    let viewModel = CategoryTypeVCViewModel()
    
    var selectedCategoryBinding: Binding<String>?
    
    private(set) var selectedCategory: String = "" {
        didSet {
            selectedCategoryBinding?(selectedCategory)
        }
    }

        init (selectedCategory: String) {
            self.selectedCategory = selectedCategory
            viewModel.delegate = self
        }
}

extension NewTrackerVCViewModel: NewTrackerVCViewModelDelegate {
    func getSelectedCategoryType(_ selectedCategoryType: String) {
        selectedCategory = selectedCategoryType
    }
}
