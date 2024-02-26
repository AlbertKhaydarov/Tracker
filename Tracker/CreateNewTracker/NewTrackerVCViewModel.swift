//
//  NewTrackerVCViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

final class NewTrackerVCViewModel {
    
//    var selectedCategoryBinding: Binding<String>?
    
    private(set) var selectedCategory: String {
        didSet {
            selectedCategoryBinding?(selectedCategory)
            print("delegate \(selectedCategory)")
        }
    }
    
    init (selectedCategory: String?) {
        self.selectedCategory = selectedCategory ?? ""
        
    }
    
    var selectedCategoryBinding: Binding<String>? {
        didSet {
            selectedCategoryBinding?(selectedCategory)
            
        }
    }
}

extension NewTrackerVCViewModel: NewTrackerVCViewModelDelegate {

    func getSelectedCategoryType(_ selectedCategory: String) {
        self.selectedCategory = selectedCategory

      }
}

