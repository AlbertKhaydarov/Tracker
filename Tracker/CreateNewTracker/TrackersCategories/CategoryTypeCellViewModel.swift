//
//  CategoryTypeCellViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

final class CategoryTypeCellViewModel: Identifiable {
    let id: String
    
    private var categoryTitle: String
    
    init (id: String, categoryTitle: String) {
        self.id = id
        self.categoryTitle = categoryTitle
    }

    var categoryTitleBinding: Binding<String>? {
        didSet {
            categoryTitleBinding?(categoryTitle)
        }
    }
   
    
}
